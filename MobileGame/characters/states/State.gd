# state.gd

extends Node2D
#extends KinematicBody2D

class_name State

var state_name
var speed
var velocity = Vector2()
var character_name
var change_state
var sprite = Sprite
var target_position = Vector2()
var persistent_state

# Writing _delta instead of delta here prevents the unused variable warning.
func _physics_process(_delta):
	persistent_state.move_and_slide(persistent_state.velocity)

func setup(change_state, target_position, character_name, sprite, persistent_state):
	self.change_state = change_state
	self.character_name = character_name
	self.sprite = sprite
	self.target_position = target_position
	self.persistent_state = persistent_state

func state_name():
	return state_name

