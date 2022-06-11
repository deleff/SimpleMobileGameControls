extends KinematicBody2D


# Declare member variables here. Examples:
var currently_attacking = null
var sprite
var state
var state_factory
var target_position = Vector2()
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
	target_position = self.position

func _input(event):
	# If hero is within range, and screen was tapped, send signal to hero to jab
	if event is InputEventScreenTouch && event.is_pressed():
		if hero_jab_range.overlaps_body(self):
			if finger.overlaps_area(self.get_node("Sprite/SpriteArea2D")):
				signal_message_queue.emit_signal("enemy_jabbed", hero, self)

## If the character was hit
func _on_character_attacked(from, to, amount_of_damage):
	if to == (self):
		print("Met  was hit by ", from)
		print("Damage taken:", amount_of_damage)

func change_state(new_state_name):
	if state != null:
		state.queue_free()
	state = state_factory.get_state(new_state_name).state.new()
	sprite = "res://characters/enemies/met/sprites/%s.png" %[new_state_name]
	state.setup(funcref(self, "change_state"), target_position, "met", "enemies", $Sprite, self, currently_attacking)
	add_child(state)
