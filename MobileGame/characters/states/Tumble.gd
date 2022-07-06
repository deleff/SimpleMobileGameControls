# TumbleState.gd

extends State

class_name TumbleState


func _ready():
	state_name = "TumbleState"
	#print(state_name, " instantiated")
	sprite.texture = load("res://characters/%s/%s/sprites/tumble.png" %[character_type, character_name])
	speed = 800
	persistent_state.collision_mask = 10
	persistent_state.collision_layer = 10

func _physics_process(_delta):
	velocity = persistent_state.global_position.direction_to(target_position) * speed
	persistent_state.velocity = (velocity)
	if persistent_state.global_position.distance_to(target_position) <= 10:
		## Turn around when almost done tumbling 
		if persistent_state.global_position.x - target_position.x < 0:
			sprite.scale.x = -1
		else:
			sprite.scale.x = 1
		## Die if out of health
		if persistent_state.current_health <= 0:
			change_state.call_func("dying")
		else:
			change_state.call_func("neutral")
