# jumping_state.gd

extends State

class_name JumpingState

#var jumping_target_position

func _ready():
	state_name = "JumpingState"
	#print(state_name, " instantiated")
	sprite.texture = load("res://characters/%s/%s/sprites/jumping.png" %[character_type, character_name])
	speed = 650
	#persistent_state.state.jumping_target_position = persistent_state.state.position
	## Face left if moving left
	if persistent_state.global_position.x - target_position.x < -50:
		sprite.scale.x = 1
		persistent_state.jumping_target_position = Vector2((persistent_state.global_position.x + 75),(persistent_state.global_position.y - 150))
		persistent_state.landing_target_position = Vector2((persistent_state.global_position.x + 150),(persistent_state.global_position.y))
	elif persistent_state.position.x - target_position.x > 50:
		sprite.scale.x = -1
		persistent_state.jumping_target_position = Vector2((persistent_state.global_position.x - 75),(persistent_state.global_position.y - 150))
		persistent_state.landing_target_position = Vector2((persistent_state.global_position.x - 150),(persistent_state.global_position.y))
	else:
		persistent_state.jumping_target_position = Vector2((persistent_state.global_position.x),(persistent_state.global_position.y - 150))
		persistent_state.landing_target_position = Vector2((persistent_state.global_position.x),(persistent_state.global_position.y))


func _input(event):
	if event is InputEventScreenTouch:
		change_state.call_func("jump_attack")

func _physics_process(_delta):
	velocity = persistent_state.global_position.direction_to(persistent_state.jumping_target_position) * speed
	persistent_state.velocity = (velocity)
	if persistent_state.global_position.distance_to(persistent_state.jumping_target_position) <= 7:
		change_state.call_func("landing")
