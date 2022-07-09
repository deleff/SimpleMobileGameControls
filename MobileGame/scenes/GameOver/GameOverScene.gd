extends Node2D

var theme

# Called when the node enters the scene tree for the first time.
func _ready():
	$NewGame.connect("pressed", self, "_on_new_game_pressed")
	if PersistentData.player_score >= PersistentData.high_score:
		PersistentData.high_score = PersistentData.player_score
		$VictoryPose.texture = load("res://characters/heroes/%s/sprites/victory_pose.png" %[PersistentData.player_1.to_lower()])
		theme = load("res://scenes/GameOver/NewHighScore.mp3")
	else:
		print("No new high score")
		$VictoryPose.texture = load("res://characters/heroes/%s/sprites/portrait.png" %[PersistentData.player_1.to_lower()])
		theme = load("res://scenes/GameOver/NormalEnding.mp3")
	$HighScoreLabel.set_text("High score: " + str(PersistentData.high_score))
	$PlayerScoreLabel.set_text("Your score: " + str(PersistentData.player_score))
	$AudioStreamPlayer2D.stream = theme
	$AudioStreamPlayer2D.play()
	if $AudioStreamPlayer2D.playing == false:
		$AudioStreamPlayer2D.stop()

func _on_new_game_pressed():
	Global.goto_scene("res://scenes/CharacterSelect/CharacterSelectScene.tscn")
