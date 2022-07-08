extends Node2D

#var player_1 = "Megaman"
onready var player_1 = "Megaman"

const MEGAMAN = preload("res://characters/heroes/megaman/Megaman.tscn")
const WILY = preload("res://characters/enemies/wily/Wily.tscn")
var theme
# Called when the node enters the scene tree for the first time.
func _ready():	
	$SignalMessageQueue.connect("met_died", self, "_on_met_died")
	## Get the user inputs
	ResourceLoader.load("res://users/")
	## Get all of the possible characte states
	ResourceLoader.load("res://characters/states/")
	## Instantiate hero
	var megaman = MEGAMAN.instance()
	add_child(megaman)
	megaman.position = Vector2(100,400)
	theme = load("res://scenes/training_mode/TrainingMode.mp3")
	$AudioStreamPlayer2D.stream = theme
	$AudioStreamPlayer2D.play()
	## Instantiate Wily
	var wily = WILY.instance()
	wily.position = Vector2(800,400)
	add_child(wily)

func _on_hero_health_update(current_health, max_health):
	$UserInterface/HeroHealthBar.value = current_health
	$UserInterface/HeroHealthBar.max_value = max_health
