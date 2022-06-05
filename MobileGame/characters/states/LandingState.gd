# idle_state.gd

extends State

class_name LandingState

var landing_target_position = Vector2()

func _ready():
	state_name = "LandingState"
	#print(state_name, " instantiated")
	sprite.texture = load("res://characters/heroes/%s/sprites/landing.png" %[character_name])
	speed = 650
	## Face left if moving left
	if persistent_state.position.x - target_position.x < -50:
		sprite.scale.x = 1
		landing_target_position = Vector2((persistent_state.position.x + 75),(persistent_state.position.y + 150))
	elif persistent_state.position.x - target_position.x > 50:
		sprite.scale.x = -1
		landing_target_position = Vector2((persistent_state.position.x - 75),(persistent_state.position.y + 150))
	else:
		landing_target_position = Vector2((persistent_state.position.x),(persistent_state.position.y + 150))

func _physics_process(_delta):
	velocity = persistent_state.position.direction_to(landing_target_position) * speed
	persistent_state.velocity = (velocity)
	if persistent_state.position.distance_to(landing_target_position) <= 7:
		change_state.call_func("neutral")
