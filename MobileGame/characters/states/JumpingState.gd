# idle_state.gd

extends State

class_name JumpingState

var jumping_target_position

func _ready():
	state_name = "JumpingState"
	#print(state_name, " instantiated")
	sprite.texture = load("res://characters/heroes/%s/sprites/jumping.png" %[character_name])
	speed = 650
	## Face left if moving left
	if persistent_state.position.x - target_position.x < -50:
		sprite.scale.x = 1
		jumping_target_position = Vector2((persistent_state.position.x + 75),(persistent_state.position.y - 150))
	elif persistent_state.position.x - target_position.x > 50:
		sprite.scale.x = -1
		jumping_target_position = Vector2((persistent_state.position.x - 75),(persistent_state.position.y - 150))
	else:
		jumping_target_position = Vector2((persistent_state.position.x),(persistent_state.position.y - 150))

func _physics_process(_delta):
	velocity = persistent_state.position.direction_to(jumping_target_position) * speed
	persistent_state.velocity = (velocity)
	if persistent_state.position.distance_to(jumping_target_position) <= 7:
		change_state.call_func("landing")
