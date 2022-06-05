# Megaman.gd

extends KinematicBody2D

class_name Megaman

var finger_on_screen = false
var sprite
var state
var state_factory
var target_position = Vector2()
var tap_count = 0
var velocity = Vector2()
onready var finger = get_parent().get_node("Finger")
onready var tapper = get_parent().get_node("Finger").get_node("Tapper")

func _ready():
	## Get character states
	state_factory = StateFactory.new()
	change_state("neutral")
	tapper.connect("timeout", self, "_on_tapper_timeout")

func _input(event):
	if event is InputEventScreenTouch && event.is_pressed():
		finger_on_screen = true
	## If the player's finger is released from the screen
	if event is InputEventScreenTouch && event.is_pressed() == false:
		finger_on_screen = false
		## If the player swiped (finger not where it started)
		if event.position != target_position:
			## Set target position
			target_position = event.position
			## If the player touched the character before lifting their finger (dragging the characer in a direction)
			if finger.overlaps_body(self):
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
	## If the player didn't tap the character
	if finger.overlaps_body(self) == false:
		target_position = tapper.tap_location
		tap_count = tapper.tap_count
		print("Tap count: ", tap_count)
		print("Tap location: ", target_position)
		if tap_count == 1:
			change_state("walking")
		else:
			change_state("running")
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
	state.setup(funcref(self, "change_state"), target_position, "megaman", $MegamanHurtbox/Sprite, self)
	add_child(state)
