# Megaman.gd

extends KinematicBody2D

class_name Megaman

var attacks = ["Jab_1_State", "Jab_2_State", "Jab_3_State", "SpecialState"]
var attack_damage
var currently_attacking = null
var finger_on_screen = false
var jab_damage = 3
var jab_window = Timer.new()
var sprite
var state
var state_factory
var special_attack_damage = 20
var target_position = Vector2()
var tap_count = 0
var velocity = Vector2()
onready var finger = get_tree().get_root().get_node("Main/Finger")
onready var tapper = get_tree().get_root().get_node("Main/Finger/Tapper")
onready var signal_message_queue = get_tree().get_root().get_node("Main/SignalMessageQueue")

func _ready():
	## Get character states
	state_factory = StateFactory.new()
	change_state("neutral")
	tapper.connect("timeout", self, "_on_tapper_timeout")
	print("Megaman info: ", self)
	signal_message_queue.connect("hit", self, "_on_character_attacked")
	signal_message_queue.connect("enemy_jabbed", self, "_on_enemy_jabbed")
	signal_message_queue.connect("enemy_special_attacked", self, "_on_enemy_special_attacked")
	add_child(jab_window)
	jab_window.set_one_shot(true)

func _on_enemy_special_attacked(hero, enemy):
	if hero == (self):
		attack_damage = jab_damage
		currently_attacking = enemy
		## If currently jabbing, continue jabbing
		if state.state_name() == "Jab_1_State" && jab_window.time_left != 0:
			change_state("jab_2")
			jab_window.start(0.5)
		elif state.state_name() == "Jab_2_State" && jab_window.time_left != 0:
			change_state("jab_3")
		else:
			attack_damage = special_attack_damage
			change_state("special")

func _on_enemy_jabbed(hero, enemy):
	if hero == (self):
		attack_damage = jab_damage
		currently_attacking = enemy
		if state.state_name() == "Jab_1_State" && jab_window.time_left != 0:
			change_state("jab_2")
			jab_window.start(0.5)
		elif state.state_name() == "Jab_2_State" && jab_window.time_left != 0:
			change_state("jab_3")
		else:
			change_state("jab_1")
			jab_window.start(0.5)

## If the player was hit
func _on_character_attacked(from, to, amount_of_damage):
	if to == (self):
		print("Megaman was hit by ", from)
		print("Damage taken:", amount_of_damage)

func _input(event):
	if event is InputEventScreenTouch && event.is_pressed():
		finger_on_screen = true
			#signal_message_queue.emit_signal("hit", self, $MegaManPivotPoint/JabRange.get_overlapping_bodies(), 20)
	## If the player's finger is released from the screen
	if event is InputEventScreenTouch && event.is_pressed() == false:
		finger_on_screen = false
		## If the player swiped (finger not where it started)
		if event.position != target_position:
			## Set target position
			target_position = event.position
			## If the player touched the character before lifting their finger (dragging the characer in a direction)
			if finger.overlaps_area(self.get_node("Sprite/SpriteArea2D")):
				## If dragging up
				if self.position.y - event.position.y > 30:
					change_state("jumping")
				## If dragging down
				elif self.position.y - event.position.y < -50 && abs(self.position.x - event.position.x) < 200:
					if state.state_name() == "NeutralState":
						change_state("taunting")
				## If dragging sideways
				elif abs(self.position.x - event.position.x) > 100:
						change_state("rolling")

## If the player tapped the screen		
func _on_tapper_timeout():
	tap_count = tapper.tap_count
	target_position = tapper.tap_location
	print("Tap count: ", tap_count)
	## If the player didn't tap the character
	if finger.overlaps_area(self.get_node("Sprite/SpriteArea2D")) == false:
		## If player is not currently attacking
		if attacks.has(state.state_name()) == false:
			if tap_count == 1:
				change_state("walking")
			else:
				change_state("running")
		else: ## If the player is currently attacking
			print("can't move, currently attacking")

	## If the player tapped and held the character
	else:
		## Can only block from a neutral states
		if state.state_name() == "NeutralState" && finger_on_screen == true:
			change_state("blocking")
			
func change_state(new_state_name):
	if state != null:
		state.queue_free()
	state = state_factory.get_state(new_state_name).state.new()
	sprite = "res://characters/heroes/megaman/sprites/%s.png" %[new_state_name]
	state.setup(funcref(self, "change_state"), target_position, "megaman", "heroes", $Sprite, self, currently_attacking, attack_damage)
	add_child(state)
