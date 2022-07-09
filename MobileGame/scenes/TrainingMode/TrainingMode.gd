extends Node2D

#var player_1 = "Megaman"
onready var player_1 = PersistentData.player_1

const MEGAMAN = preload("res://characters/heroes/megaman/Megaman.tscn")
const ROLL = preload("res://characters/heroes/roll/Roll.tscn")
const WILY = preload("res://characters/enemies/wily/Wily.tscn")
var theme
var tutorial_position = 0
# Called when the node enters the scene tree for the first time.
func _ready():	
	$NewGame.connect("pressed", self, "_on_new_game_pressed")
	$SignalMessageQueue.connect("state_update", self, "_on_player_state_update")
	## Get the user inputs
	ResourceLoader.load("res://users/")
	## Get all of the possible characte states
	ResourceLoader.load("res://characters/states/")
	## Instantiate hero
	## Instantiate hero
	if player_1 == "Megaman":
		var megaman = MEGAMAN.instance()
		$YSort.add_child(megaman)
		megaman.position = Vector2(100,400)
	else:
		var Roll = ROLL.instance()
		$YSort.add_child(Roll)
		Roll.position = Vector2(100,400)
	theme = load("res://scenes/TrainingMode/TrainingMode.mp3")
	$AudioStreamPlayer2D.stream = theme
	$AudioStreamPlayer2D.play()
	## Instantiate Wily
	var wily = WILY.instance()
	wily.position = Vector2(800,400)
	$YSort.add_child(wily)
	$UserInterface/Tutorial.text = tutorial[0]

func _on_new_game_pressed():
	Global.goto_scene("res://scenes/CharacterSelect/CharacterSelectScene.tscn")

var tutorial = [
	"Welcome to training mode, here's how to play the game.\nTap the screen to walk.",
	"Now double tap to run.",
	"Okay, now for some more complex moves.\nDrag yourself up to jump.",
	"Drag yourself sideways to roll.",
	"Let's have some fun. Drag yourself down to taunt.",
	"Now tap and hold yourself to block.",
	"When standing next to an enemy, tap it to jab.",
	"Great, now double-tap the enemy to use a special attack.",
	"Stand next to an enemy and drag it left or right to throw.",
	"Now back off. Jump and tap the screen to do a jump attack.",
	"Finally, tap an enemy while running towards it to for a dash attack.",
	"Great. Looks like you're ready to play the game!"
	]

func _on_player_state_update(character_name, state):
	if character_name.to_lower() == player_1.to_lower():
		#print("New state: ", state)
		match tutorial_position:
			0: 
				if state == "walking":
					$UserInterface/Tutorial.text = tutorial[1]
					tutorial_position += 1
			1: 
				if state == "running":
					$UserInterface/Tutorial.text = tutorial[2]
					tutorial_position += 1
			2: 
				if state == "jumping":
					$UserInterface/Tutorial.text = tutorial[3]
					tutorial_position += 1
			3: 
				if state == "rolling":
					$UserInterface/Tutorial.text = tutorial[4]
					tutorial_position += 1
			4: 
				if state == "taunting":
					$UserInterface/Tutorial.text = tutorial[5]
					tutorial_position += 1
			5: 
				if state == "blocking":
					$UserInterface/Tutorial.text = tutorial[6]
					tutorial_position += 1
			6: 
				if state == "jab_1":
					$UserInterface/Tutorial.text = tutorial[7]
					tutorial_position += 1
			7: 
				if state == "special":
					$UserInterface/Tutorial.text = tutorial[8]
					tutorial_position += 1
			8: 
				if state == "throwing":
					$UserInterface/Tutorial.text = tutorial[9]
					tutorial_position += 1
			9: 
				if state == "jump_attack" || state == "landing_attack":
					$UserInterface/Tutorial.text = tutorial[10]
					tutorial_position += 1
			10: 
				if state == "dash_attack":
					$UserInterface/Tutorial.text = tutorial[11]
