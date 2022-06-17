# ThrowingState.gd

extends State

class_name ThrowingState

var hit_direction
var throw_hit_lag = Timer.new()

func _ready():
	state_name = "ThrowingState"
	#print(state_name, " instantiated")
	sprite.texture = load("res://characters/%s/%s/sprites/throwing.png" %[character_type,character_name])
	add_child(throw_hit_lag)
	throw_hit_lag.set_one_shot(true)
	throw_hit_lag.connect("timeout", self, "_on_throw_hit_lag_end")
	throw_hit_lag.start(0.5)
	
	## Determine which way the character is facing
	if persistent_state.position.x - target_position.x < 0:
		hit_direction = "right"
		sprite.scale.x = 1
	else:
		hit_direction = "left"
		sprite.scale.x = -1
	persistent_state.signal_message_queue.emit_signal("hit", persistent_state, currently_attacking, attack_damage, hit_direction)
	#persistent_state.currently_attacking = null

func _physics_process(_delta):
	velocity = persistent_state.position.direction_to(persistent_state.position)
	persistent_state.velocity = (velocity)

func _on_throw_hit_lag_end():
	change_state.call_func("neutral")
