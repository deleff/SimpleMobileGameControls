# jab_2_state.gd

extends State

class_name Jab_2_State

var hit_direction
var state_jab_window = Timer.new()

func _ready():
	state_name = "Jab_2_State"
	#print(state_name, " instantiated")
	sprite.texture = load("res://characters/%s/%s/sprites/Jab_2_State.png" %[character_type, character_name])
	add_child(state_jab_window)
	state_jab_window.set_one_shot(true)
	state_jab_window.connect("timeout", self, "_on_jab_window_close")
	state_jab_window.start(0.5)
	
	## Determine which way the character is facing
	if persistent_state.position.x - target_position.x < 0:
		hit_direction = "right"
	else:
		hit_direction = "left"
	persistent_state.signal_message_queue.emit_signal("hit", persistent_state, currently_attacking, attack_damage, hit_direction)
	#persistent_state.currently_attacking = null

func _on_jab_window_close():
	change_state.call_func("neutral")
