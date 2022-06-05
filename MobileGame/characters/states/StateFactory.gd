# state_factory.gd

class_name StateFactory

var states

func _init():
	states = {
		"neutral":  NeutralState,
		"walking":  WalkingState,
		"running":  RunningState,
		"rolling":  RollingState,
		"jumping":  JumpingState,
		"landing":  LandingState,
		"blocking": BlockingState,
		"taunting": TauntingState
	}

func get_state(state_name):
	if states.has(state_name):
		var state = states.get(state_name)
		var sprite = state_name
		return {"state":state, "sprite":sprite}
	else:
		printerr("No state ", state_name, " in state factory!")
