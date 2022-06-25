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
	## Set Megaman's starting position
	self.get_node("MegamanNode/Megaman").position = Vector2(100,400)
	
	self.get_node("MetNode").position = Vector2(800,400)
	
	self.get_node("MetSho")
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
