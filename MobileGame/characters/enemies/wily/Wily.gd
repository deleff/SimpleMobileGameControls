extends Character

class_name Wily

var state_change_timer = Timer.new()
var spawn_position: Vector2

## Get human player
onready var player_1 = get_tree().get_root().get_node("MainGame").player_1

onready var finger = get_tree().get_root().get_node("MainGame/Finger")
onready var tapper = get_tree().get_root().get_node("MainGame/Finger/Tapper")
#onready var signal_message_queue = get_tree().get_root().get_node("MainGame/SignalMessageQueue")
onready var hero = get_tree().get_root().get_node("MainGame/YSort/%s" %[player_1])
onready var hero_jab_range = get_tree().get_root().get_node("MainGame/YSort/%s/PivotPoint/JabRange" %[player_1])
onready var hero_position = get_tree().get_root().get_node("MainGame/YSort/%s/PivotPoint" %[player_1])
# Called when the node enters the scene tree for the first time.
func _ready():
	signal_message_queue = get_tree().get_root().get_node("MainGame/SignalMessageQueue")
	character_name = "wily"
	character_type = "enemies"
	audio = $AudioStreamPlayer2D
	state_factory = StateFactory.new()
	change_state("neutral")
	signal_message_queue.connect("hit", self, "_on_character_attacked")
	tapper.connect("timeout", self, "_on_tapper_timeout")
	max_health = 300
	current_health = max_health
	add_child(state_change_timer)
	state_change_timer.connect("timeout", self, "_on_state_change_timeout")
	state_change_timer.start(0.3)
	spawn_position = self.global_position
	$Sprite.scale.x = -1

## Return to starting position if Wily has been hit
func _on_state_change_timeout():
	if state.state_name() == "NeutralState":
		var distance_to_spawn = self.global_position.distance_to(spawn_position)
		if(distance_to_spawn > 10):
			target_position = spawn_position
			change_state("walking")

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
			## If in tumble, canpile on the damage
			if state.state_name() != "TumbleState":
				if amount_of_damage < 10: ## hitstun
					if hit_direction == "left":
						target_position = Vector2((self.global_position.x - 5), self.global_position.y)
					else:
						target_position = Vector2((self.global_position.x + 5), self.global_position.y)
					change_state("hit_stun")
				else: ## tumble
					if hit_direction == "left":
						target_position = Vector2((self.global_position.x - 500), self.global_position.y)
					else:
						target_position = Vector2((self.global_position.x + 500), self.global_position.y)
					change_state("tumble")
					
