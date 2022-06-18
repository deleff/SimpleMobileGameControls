# hit_stun_state.gd

extends State

class_name HitStunState

func _ready():
	state_name = "HitStunState"
	#print(state_name, " instantiated")
	sprite.texture = load("res://characters/%s/%s/sprites/hitstun.png" %[character_type, character_name])
	speed = 300

func _physics_process(_delta):
	velocity = persistent_state.position.direction_to(target_position) * speed
	persistent_state.velocity = (velocity)
	if persistent_state.position.distance_to(target_position) <= 5:
		change_state.call_func("neutral")
