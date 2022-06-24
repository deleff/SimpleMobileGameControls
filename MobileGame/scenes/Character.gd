# Character class

extends KinematicBody2D

class_name Character

var attacks = ["Jab_1_State", "Jab_2_State", "Jab_3_State", "SpecialState", "DashAttackState", "ThrowingState"]
var attack_damage: int
var character_name: String
var character_type: String
var currently_attacking: Object
var current_health: int
var finger_on_screen: bool = false
var dash_attack_damage: int
var health: int
var jab_damage: int
var jab_window = Timer.new()
var jumping_target_position: Vector2
var landing_target_position: Vector2
var max_health: int
var state: State
var state_factory: StateFactory
var special_attack_damage: int
var target_position: Vector2
var target_character: KinematicBody2D
var tap_count: int = 0
var tap_entered_location: Vector2
var tap_exited_location: Vector2
var throw_direction: String
var velocity: Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func change_state(new_state_name):
	if state != null:
		state.queue_free()
	state = state_factory.get_state(new_state_name).state.new()
	state.setup(funcref(self, "change_state"), target_position, character_name, character_type, $Sprite, self, currently_attacking, attack_damage)
	add_child(state)
