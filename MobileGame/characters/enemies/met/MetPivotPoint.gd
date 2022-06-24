extends Character

class_name Met

# Declare member variables here. Examples:

onready var finger = get_tree().get_root().get_node("Main/Finger")
onready var tapper = get_tree().get_root().get_node("Main/Finger/Tapper")
onready var signal_message_queue = get_tree().get_root().get_node("Main/SignalMessageQueue")
onready var hero = get_tree().get_root().get_node("Main/MegamanNode/Megaman")
onready var hero_jab_range = get_tree().get_root().get_node("Main/MegamanNode/Megaman/MegaManPivotPoint/JabRange")
onready var hero_position = get_tree().get_root().get_node("Main/MegamanNode/Megaman/MegaManPivotPoint")
# Called when the node enters the scene tree for the first time.
func _ready():
	character_name = "met"
	character_type = "enemies"
	print("Met info: ", self)
	state_factory = StateFactory.new()
	change_state("neutral")
	signal_message_queue.connect("hit", self, "_on_character_attacked")
	tapper.connect("timeout", self, "_on_tapper_timeout")
	$CharacterDetectorArea2D.connect("body_entered", self, "_on_character_detected")
	$CharacterDetectorArea2D.connect("body_exited", self, "_on_character_lost")
	target_position = self.global_position

func _on_character_lost(body):
	if body == hero:
		change_state("neutral")

func _on_character_detected(body):
	if body == hero:
		print("Hero detected")
		currently_attacking = hero
		target_position = body.global_position
		change_state("following")
	else:
		print("Not the momma, it's ", body)

func _input(event):
	if event is InputEventScreenTouch && event.is_pressed():
		finger_on_screen = true
		tap_entered_location = event.position 
		if finger.overlaps_area(self.get_node("Sprite/SpriteArea2D")):
			signal_message_queue.emit_signal("enemy_tapped", hero, self)
	elif event is InputEventScreenTouch && event.is_pressed() == false:
		finger_on_screen = false
		tap_exited_location = event.position
		# If hero is within range, and screen was tapped, send signal to hero to jab
		if hero_jab_range.overlaps_body(self):
			## If the player touched the character before lifting their finger (dragging the characer in a direction)
			if finger.overlaps_area(self.get_node("Sprite/SpriteArea2D")):
				## If dragging sideways
				if abs(tap_entered_location.x - tap_exited_location.x) > 100:
					if (tap_entered_location.x - tap_exited_location.x) > 0:
						throw_direction = "left"
					else:
						throw_direction = "right"
					signal_message_queue.emit_signal("enemy_thrown", hero, self, throw_direction)

func _on_tapper_timeout():
	tap_count = tapper.tap_count
	## If not currently holding down
	if finger_on_screen == false:
		# If hero is within range, and screen was tapped, send signal to hero to jab
		if hero_jab_range.overlaps_body(self):
			if finger.overlaps_area(self.get_node("Sprite/SpriteArea2D")):
				if tap_count == 1:
					signal_message_queue.emit_signal("enemy_jabbed", hero, self)
				else:
					signal_message_queue.emit_signal("enemy_special_attacked", hero, self)

## If the character was hit
func _on_character_attacked(from, to, attack_type, amount_of_damage, hit_direction):
	## If blocking
	if to == self && hero_jab_range.overlaps_body(self):
		## Can be hit if not blocking, or if blocking but attack is a throw
		if (state.state_name() == "BlockingState" && attack_type == "throw") ||  state.state_name() != "BlockingState":
			print("Met was hit by ", from)
			print("Damage taken:", amount_of_damage)
			if amount_of_damage < 10: ## hitstun
				if hit_direction == "left":
					target_position = Vector2((self.global_position.x - 20), self.global_position.y)
				else:
					target_position = Vector2((self.global_position.x + 20), self.global_position.y)
					print("MET HIT RIGHT")
				change_state("hit_stun")
			else: ## tumble
				if hit_direction == "left":
					target_position = Vector2((self.global_position.x - 300), self.global_position.y)
				else:
					target_position = Vector2((self.global_position.x + 300), self.global_position.y)
				change_state("tumble")
