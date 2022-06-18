# blocking_state.gd

extends State

class_name BlockingState

func _ready():
	state_name = "BlockingState"
	#print(state_name, " instantiated")
	sprite.texture = load("res://characters/%s/%s/sprites/blocking.png" %[character_type, character_name])

func _input(event):
	## If the player's finger is released from the screen
	if event is InputEventScreenTouch && event.is_pressed() == false:
		change_state.call_func("neutral")
