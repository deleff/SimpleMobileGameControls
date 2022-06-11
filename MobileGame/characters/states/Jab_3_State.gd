# idle_state.gd

extends State

class_name Jab_3_State

var state_jab_window = Timer.new()

func _ready():
	state_name = "Jab_3_State"
	#print(state_name, " instantiated")
	sprite.texture = load("res://characters/%s/%s/sprites/Jab_3_State.png" %[character_type, character_name])
	persistent_state.signal_message_queue.emit_signal("hit", persistent_state, currently_attacking, 3)
	persistent_state.currently_attacking = null
	add_child(state_jab_window)
	state_jab_window.set_one_shot(true)
	state_jab_window.connect("timeout", self, "_on_jab_window_close")
	state_jab_window.start(0.3)

func _on_jab_window_close():
	change_state.call_func("neutral")
