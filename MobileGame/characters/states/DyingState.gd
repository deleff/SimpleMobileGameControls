# neutral_state.gd

extends State

class_name DyingState

var dying_animation_timer = Timer.new()
var death_sequence_timer = Timer.new()

func _ready():
	state_name = "DyingState"
	persistent_state.collision_mask = 1
	#print(state_name, " instantiated")
	sprite.texture = load("res://characters/%s/%s/sprites/dying.png" %[character_type, character_name])
	add_child(dying_animation_timer)
	dying_animation_timer.connect("timeout", self, "_on_animation_timeout")
	dying_animation_timer.start(0.1)
	add_child(death_sequence_timer)
	death_sequence_timer.connect("timeout", self, "_on_death_sequence_timeout")
	death_sequence_timer.start(0.7)
	target_position = self.global_position
	persistent_state.collision_mask = 10

	var start_sound = load("res://characters/%s/%s/sfx/dying.wav" %[character_type, character_name])
	persistent_state.audio.stream = start_sound
	persistent_state.audio.play()

func _on_death_sequence_timeout():
	if persistent_state.character_type == "enemies":
		persistent_state.signal_message_queue.emit_signal("met_died")
		persistent_state.queue_free()
	else:
		PersistentData.player_score = get_tree().get_root().get_node("MainGame").score
		Global.goto_scene("res://scenes/GameOverScene.tscn")
	
func _on_animation_timeout():
	sprite.scale.x *= -1
	target_position = Vector2((target_position.x), (target_position.y * -1))
	
func _physics_process(_delta):
	velocity = global_position.direction_to(target_position) * 200
	persistent_state.velocity = (velocity)
