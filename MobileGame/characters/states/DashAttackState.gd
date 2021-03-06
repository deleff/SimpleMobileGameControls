# dash_attack_state.gd

extends State

class_name DashAttackState

var hit_direction

func _ready():
	state_name = "DashAttackState"
	#print(state_name, " instantiated")
	sprite.texture = load("res://characters/%s/%s/sprites/dash_attack.png" %[character_type, character_name])
	speed = 450
	## Face left if moving left
	if persistent_state.global_position.x - target_position.x > 0:
		sprite.scale.x = -1
	else:
		sprite.scale.x = 1

	## Determine which way the character is facing
	if persistent_state.global_position.x - target_position.x < 0:
		hit_direction = "right"
	else:
		hit_direction = "left"

	var start_sound = load("res://characters/%s/%s/sfx/dash_attack.wav" %[character_type, character_name])
	persistent_state.audio.stream = start_sound
	persistent_state.audio.play()

func _physics_process(_delta):
	velocity = persistent_state.global_position.direction_to(target_position) * speed
	persistent_state.velocity = (velocity)
	persistent_state.signal_message_queue.emit_signal("hit", persistent_state, currently_attacking, "dash_attack", attack_damage, hit_direction)
	if persistent_state.global_position.distance_to(target_position) <= 5:
		change_state.call_func("neutral")
