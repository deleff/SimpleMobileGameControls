# state_factory.gd

class_name StateFactory

var states

func _init():
	states = {
		"neutral":        NeutralState,
		"walking":        WalkingState,
		"following":      FollowingState,
		"running":        RunningState,
		"rolling":        RollingState,
		"jumping":        JumpingState,
		"jump_attack":    JumpAttackState,
		"landing_attack": LandingAttackState,
		"landing":        LandingState,
		"blocking":       BlockingState,
		"taunting":       TauntingState,
		"jab_1":          Jab_1_State,
		"jab_2":          Jab_2_State,
		"jab_3":          Jab_3_State,
		"special":        SpecialAttackState,
		"dash_attack":    DashAttackState,
		"throwing":       ThrowingState,
		"hit_stun":       HitStunState,
		"tumble":         TumbleState,
		"dying":          DyingState
	}

func get_state(state_name):
	if states.has(state_name):
		var state = states.get(state_name)
		var sprite = state_name
		return {"state":state, "sprite":sprite}
	else:
		printerr("No state ", state_name, " in state factory!")
