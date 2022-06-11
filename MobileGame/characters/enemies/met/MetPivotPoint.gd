extends KinematicBody2D


# Declare member variables here. Examples:
var attack_damage
var currently_attacking = null
var sprite
var state
var state_factory
var target_position = Vector2()
var tap_count
var velocity = Vector2()

onready var finger = get_tree().get_root().get_node("Main/Finger")
onready var tapper = get_tree().get_root().get_node("Main/Finger/Tapper")
onready var signal_message_queue = get_tree().get_root().get_node("Main/SignalMessageQueue")
onready var hero = get_tree().get_root().get_node("Main/MegamanNode/Megaman")
onready var hero_jab_range = get_tree().get_root().get_node("Main/MegamanNode/Megaman/MegaManPivotPoint/JabRange")
# Called when the node enters the scene tree for the first time.
func _ready():
	print("Met info: ", self)
	state_factory = StateFactory.new()
	change_state("neutral")
	signal_message_queue.connect("hit", self, "_on_character_attacked")
	tapper.connect("timeout", self, "_on_tapper_timeout")
	target_position = self.position

func _on_tapper_timeout():
	tap_count = tapper.tap_count
	# If hero is within range, and screen was tapped, send signal to hero to jab
	if hero_jab_range.overlaps_body(self):
		if finger.overlaps_area(self.get_node("Sprite/SpriteArea2D")):
			if tap_count == 1:
				signal_message_queue.emit_signal("enemy_jabbed", hero, self)
			else:
				signal_message_queue.emit_signal("enemy_special_attacked", hero, self)

## If the character was hit
func _on_character_attacked(from, to, amount_of_damage, hit_direction):
	if to == (self) && state.state_name() != "BlockingState":
		print("Met was hit by ", from)
		print("Damage taken:", amount_of_damage)
		if amount_of_damage < 10: ## hitstun
			if hit_direction == "left":
				target_position = Vector2((self.position.x - 20), self.position.y)
			else:
				target_position = Vector2((self.position.x + 20), self.position.y)
				print("MET HIT RIGHT")
			change_state("hit_stun")
		else: ## tumble
			if hit_direction == "left":
				target_position = Vector2((self.position.x - 300), self.position.y)
			else:
				target_position = Vector2((self.position.x + 300), self.position.y)
			change_state("tumble")


func change_state(new_state_name):
	if state != null:
		state.queue_free()
	state = state_factory.get_state(new_state_name).state.new()
	sprite = "res://characters/enemies/met/sprites/%s.png" %[new_state_name]
	state.setup(funcref(self, "change_state"), target_position, "met", "enemies", $Sprite, self, currently_attacking, attack_damage)
	add_child(state)
