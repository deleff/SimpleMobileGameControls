# jump_attack_state.gd

extends State

class_name JumpAttackState

#var jumping_target_position
var hit_direction

func _ready():
	state_name = "JumpAttackState"
	#print(state_name, " instantiated")
	sprite.texture = load("res://characters/%s/%s/sprites/jump_attack.png" %[character_type, character_name])
	speed = 650

	## Determine which way the character is facing
	if persistent_state.global_position.x - target_position.x < 0:
		hit_direction = "right"
	else:
		hit_direction = "left"

func _physics_process(_delta):
	velocity = persistent_state.global_position.direction_to(persistent_state.jumping_target_position) * speed
	persistent_state.velocity = (velocity)
	persistent_state.signal_message_queue.emit_signal("hit", persistent_state, currently_attacking, "jump_attack", attack_damage, hit_direction)
	if persistent_state.global_position.distance_to(persistent_state.jumping_target_position) <= 7:
		change_state.call_func("landing")
