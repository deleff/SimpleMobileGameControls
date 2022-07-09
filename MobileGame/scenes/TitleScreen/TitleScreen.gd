extends Node2D


var text_timer = Timer.new()
var theme
var transition_period = 2
var transition_position = 0

var intro_text = [
	"Dedicated to Albert Bitton.\nWho banned me from using Mega Man for being \"too cheap\",\nand hated Roll's theme.",
	"This is just a fan game.\nAll characters and music, and sound effects are owned by Capcom Co., Ltd.",
	"Yitzchak Eleff presents",
	"Yitzchak Eleff presents\nMET MADNESS",
	"Yitzchak Eleff presents\nMET MADNESS\n\n\n\nTap to begin"
	]

# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(text_timer)
	text_timer.connect("timeout", self, "_on_text_timer_timeout")
	text_timer.start(3)
	$Tween/RichTextLabel.text = intro_text[0]
	$Tween.interpolate_property($Tween/RichTextLabel, "modulate:a", 0, 1, transition_period, Tween.EASE_IN_OUT)
	$Tween.start()

func _input(event):
	if event is InputEventScreenTouch && event.is_pressed() == false:
		if transition_position < 5:
			text_timer.start(0.05)
			transition_position = 5
			theme = load("res://scenes/TitleScreen/TitleScreen.mp3")
			$AudioStreamPlayer2D.stream = theme
			$AudioStreamPlayer2D.play()
	elif transition_position > 5:
		Global.goto_scene("res://scenes/CharacterSelect/CharacterSelectScene.tscn")


func _on_text_timer_timeout():
	transition_position += 1
	match transition_position:
			1: 
				$Tween.interpolate_property($Tween/RichTextLabel, "modulate:a", 1, 0, transition_period, Tween.EASE_IN_OUT)
				$Tween.start()
			2: 
				theme = load("res://scenes/TitleScreen/CapcomLogo.mp3")
				$AudioStreamPlayer2D.stream = theme
				$AudioStreamPlayer2D.play()
				$Tween/RichTextLabel.text = intro_text[1]
				$Tween.interpolate_property($Tween/RichTextLabel, "modulate:a", 0, 1, transition_period, Tween.EASE_IN_OUT)
				$Tween.start()
				$Tween.interpolate_property($Tween/CapcomLogo, "modulate:a", 0, 1, transition_period, Tween.EASE_IN_OUT)
				$Tween.start()
				$Tween/CapcomLogo.visible = true
			3: 
				$Tween.interpolate_property($Tween/RichTextLabel, "modulate:a", 1, 0, transition_period, Tween.EASE_IN_OUT)
				$Tween.start()
				$Tween.interpolate_property($Tween/CapcomLogo, "modulate:a", 1, 0, transition_period, Tween.EASE_IN_OUT)
				$Tween.start()
			4: 
				theme = load("res://scenes/TitleScreen/TitleScreen.mp3")
				$AudioStreamPlayer2D.stream = theme
				$AudioStreamPlayer2D.play()
				$Tween/RichTextLabel.text = intro_text[2]
				$Tween.interpolate_property($Tween/RichTextLabel, "modulate:a", 0, 1, transition_period, Tween.EASE_IN_OUT)
				$Tween.start()
				$ParallaxBackground/BackgroundImage.visible = true
			5: 
				$Tween/RichTextLabel.text = intro_text[3]
				text_timer.start(3)
			6: 
				$Tween/RichTextLabel.text = intro_text[4]
				$ParallaxBackground/BackgroundImage.visible = true


