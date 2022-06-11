# SpecialAttackState.gd

extends State

class_name SpecialAttackState

var hit_direction
var special_hit_lag = Timer.new()

func _ready():
	state_name = "SpecialAttackState"
	#print(state_name, " instantiated")
	sprite.texture = load("res://characters/%s/%s/sprites/special.png" %[character_type,character_name])
	add_child(special_hit_lag)
	special_hit_lag.set_one_shot(true)
	special_hit_lag.connect("timeout", self, "_on_special_hit_lag_end")
	special_hit_lag.start(0.5)
	
	## Determine which way the character is facing
	if persistent_state.position.x - target_position.x < 0:
		hit_direction = "right"
	else:
		hit_direction = "left"
	persistent_state.signal_message_queue.emit_signal("hit", persistent_state, currently_attacking, attack_damage, hit_direction)
	#persistent_state.currently_attacking = null

func _on_special_hit_lag_end():
	change_state.call_func("neutral")
