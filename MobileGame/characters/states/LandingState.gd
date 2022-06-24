# landing_state.gd

extends State

class_name LandingState

#var landing_target_position = Vector2()

func _ready():
	state_name = "LandingState"
	#print(state_name, " instantiated")
	sprite.texture = load("res://characters/%s/%s/sprites/landing.png" %[character_type, character_name])
	speed = 650

func _input(event):
	if event is InputEventScreenTouch:
		change_state.call_func("landing_attack")

func _physics_process(_delta):
	velocity = persistent_state.global_position.direction_to(persistent_state.landing_target_position) * speed
	persistent_state.velocity = (velocity)
	if persistent_state.global_position.distance_to(persistent_state.landing_target_position) <= 7:
		change_state.call_func("neutral")
