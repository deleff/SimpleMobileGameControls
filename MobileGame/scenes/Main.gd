extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	## Get the user inputs
	ResourceLoader.load("res://users/")
	
	## Get all of the possible characte states
	ResourceLoader.load("res://characters/states/")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
