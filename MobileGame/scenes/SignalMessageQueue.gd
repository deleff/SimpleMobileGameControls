extends Node2D


# Declare member variables here. Examples:
#onready var finger = get_parent().get_node("Finger")
#onready var tapper =get_parent().get_node("Finger").get_node("Tapper")
#onready var hero = get_parent().get_node("MegamanNode")
#onready var met = preload("res://characters/enemies/met/MetNode.tscn")

# Called when the node enters the scene tree for the first time.
#func _ready():
#	pass

signal hit(from, to, amount_of_damage)
signal enemy_jabbed(hero, enemy)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
