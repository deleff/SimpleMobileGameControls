# taunting_state.gd

extends State

class_name TauntingState

var taunt_timer = Timer.new()

func _ready():
	state_name = "TauntingState"
	#print(state_name, " instantiated")
	sprite.texture = load("res://characters/%s/%s/sprites/taunting.png" %[character_type, character_name])
	add_child(taunt_timer)
	taunt_timer.set_one_shot(true)
	taunt_timer.connect("timeout", self, "_on_taunt_timeout")
	taunt_timer.start(0.5)

	var start_sound = load("res://characters/%s/%s/sfx/taunt.wav" %[character_type, character_name])
	persistent_state.audio.stream = start_sound
	persistent_state.audio.play()

func _on_taunt_timeout():
	change_state.call_func("neutral")
