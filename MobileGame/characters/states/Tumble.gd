# TumbleState.gd

extends State

class_name TumbleState

var jumping_target_position

func _ready():
	state_name = "TumbleState"
	#print(state_name, " instantiated")
	sprite.texture = load("res://characters/%s/%s/sprites/tumble.png" %[character_type, character_name])
	speed = 800

func _physics_process(_delta):
	velocity = persistent_state.position.direction_to(target_position) * speed
	persistent_state.velocity = (velocity)
	if persistent_state.position.distance_to(target_position) <= 5:
		## Turn around when almost done tumbling 
		if persistent_state.position.x - target_position.x < 0:
			sprite.scale.x = -1
		else:
			sprite.scale.x = 1
		change_state.call_func("neutral")
