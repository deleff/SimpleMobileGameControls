# rolling_state.gd

extends State

class_name RollingState

var rolling_target_position = Vector2()

func _ready():
	state_name = "RollingState"
	#print(state_name, " instantiated")
	sprite.texture = load("res://characters/%s/%s/sprites/rolling.png" %[character_type, character_name])
	speed = 450
	## Face left if moving left
	if persistent_state.global_position.x - target_position.x < 0:
		sprite.scale.x = 1
		rolling_target_position = Vector2((persistent_state.global_position.x + 150),persistent_state.position.y)
	else:
		sprite.scale.x = -1
		rolling_target_position = Vector2((persistent_state.global_position.x - 150),persistent_state.position.y)

func _physics_process(_delta):
	velocity = persistent_state.global_position.direction_to(rolling_target_position) * speed
	persistent_state.velocity = (velocity)
	if persistent_state.global_position.distance_to(rolling_target_position) <= 5:
		sprite.scale.x *= -1 ## Face the enemy after rolling
		change_state.call_func("neutral")
