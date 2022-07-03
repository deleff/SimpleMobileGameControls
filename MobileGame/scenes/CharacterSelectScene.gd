extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var player_1: String = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	$AudioStreamPlayer2D.play()
	$Label/MegamanIcon.connect("pressed", self, "_on_megaman_selected")
	$Label/RollIcon.connect("pressed", self, "_on_roll_selected")

func _on_megaman_selected():
	$Label/CharacterLogo.texture = load("res://characters/heroes/megaman/sprites/logo.png")
	player_1 = "Megaman"
	print("Player 1: ", player_1)
	$TrainingMode.disabled = false
	$TrainingMode.visible = true
	$StartGame.disabled = false
	$StartGame.visible = true

func _on_roll_selected():
	$Label/CharacterLogo.texture = load("res://characters/heroes/roll/sprites/logo.png")
	player_1 = "Roll"
	print("Player 1: ", player_1)
	$TrainingMode.disabled = false
	$TrainingMode.visible = true
	$StartGame.disabled = false
	$StartGame.visible = true


func _input(event):
	if event is InputEventScreenTouch && event.is_pressed():
		pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
