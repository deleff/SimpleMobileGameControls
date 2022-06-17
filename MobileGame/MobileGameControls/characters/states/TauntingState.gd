# idle_state.gd

extends State

class_name TauntingState

var taunt_timer = Timer.new()

func _ready():
	state_name = "TauntingState"
	#print(state_name, " instantiated")
	sprite.texture = load("res://characters/heroes/%s/sprites/taunting.png" %[character_name])
	add_child(taunt_timer)
	taunt_timer.set_one_shot(true)
	taunt_timer.connect("timeout", self, "_on_taunt_timeout")
	taunt_timer.start(0.5)
	
func _on_taunt_timeout():
	change_state.call_func("neutral")
