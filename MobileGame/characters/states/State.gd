# state.gd

extends Node2D
#extends KinematicBody2D

class_name State

var attack_damage
var state_name
var speed
var velocity = Vector2()
var character_name
var change_state
var character_type
var currently_attacking
var jumping_target_position = Vector2()
var landing_target_position = Vector2()
var sprite = Sprite
var target_position = Vector2()
var persistent_state

# Writing _delta instead of delta here prevents the unused variable warning.
func _physics_process(_delta):
	persistent_state.move_and_slide(persistent_state.velocity)
	if persistent_state.get_slide_count() > 1:
		persistent_state.change_state("neutral")

func setup(change_state, target_position, character_name, character_type, sprite, persistent_state, currently_attacking, attack_damage):
	self.attack_damage = attack_damage
	self.change_state = change_state
	self.character_name = character_name
	self.character_type = character_type
	self.currently_attacking = currently_attacking
	self.sprite = sprite
	self.target_position = target_position
	self.persistent_state = persistent_state

func state_name():
	return state_name

