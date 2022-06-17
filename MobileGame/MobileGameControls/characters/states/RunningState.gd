# idle_state.gd

extends State

class_name RunningState

func _ready():
	state_name = "RunningState"
	#print(state_name, " instantiated")
	sprite.texture = load("res://characters/heroes/%s/sprites/running.png" %[character_name])
	speed = 550
	## Face left if moving left
	if persistent_state.position.x - target_position.x > 0:
		sprite.scale.x = -1
	else:
		sprite.scale.x = 1

func _physics_process(_delta):
	velocity = persistent_state.position.direction_to(target_position) * speed
	persistent_state.velocity = (velocity)
	if persistent_state.position.distance_to(target_position) <= 5:
		change_state.call_func("neutral")
