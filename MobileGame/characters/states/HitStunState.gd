# hit_stun_state.gd

extends State

class_name HitStunState

var hit_stun_timer = Timer.new()

func _ready():
	state_name = "HitStunState"
	#print(state_name, " instantiated")
	sprite.texture = load("res://characters/%s/%s/sprites/hit_stun.png" %[character_type, character_name])
	speed = 300
	add_child(hit_stun_timer)
	hit_stun_timer.set_one_shot(true)
	hit_stun_timer.connect("timeout", self, "_on_hitstun_timeout")
	hit_stun_timer.start(0.15)

func _on_hitstun_timeout():
	change_state.call_func("neutral")

func _physics_process(_delta):
	velocity = persistent_state.global_position.direction_to(target_position) * speed
	persistent_state.velocity = (velocity)
	if persistent_state.global_position.distance_to(target_position) <= 5:
		pass
