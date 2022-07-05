extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	$AudioStreamPlayer2D.play()
	$Label/MegamanIcon.connect("pressed", self, "_on_megaman_selected")
	$Label/RollIcon.connect("pressed", self, "_on_roll_selected")
	$StartGame.connect("pressed", self, "_on_start_game_pressed")
	$StartGame.set_block_signals(true)
	$TrainingMode.set_block_signals(true)

func _on_megaman_selected():
	$Label/CharacterLogo.texture = load("res://characters/heroes/megaman/sprites/logo.png")
	PersistentData.player_1 = "Megaman"
	print("Player 1: ", PersistentData.player_1)
	$TrainingMode.set_block_signals(false)
	$TrainingMode.visible = true
	$StartGame.set_block_signals(false)
	$StartGame.visible = true

func _on_roll_selected():
	$Label/CharacterLogo.texture = load("res://characters/heroes/roll/sprites/logo.png")
	PersistentData.player_1 = "Roll"
	print("Player 1: ", PersistentData.player_1)
	$TrainingMode.set_block_signals(false)
	$TrainingMode.visible = true
	$StartGame.set_block_signals(false)
	$StartGame.visible = true

func _on_start_game_pressed():
	Global.goto_scene("res://scenes/MainGame.tscn")
