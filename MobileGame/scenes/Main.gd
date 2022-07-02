extends Node2D

var player_1 = "megaman"

const MEGAMAN = preload("res://characters/heroes/megaman/Megaman.tscn")
const ROLL = preload("res://characters/heroes/megaman/Megaman.tscn")
const MET = preload("res://characters/enemies/met/Met.tscn")
var met_spawner_timer = Timer.new()
var met_count = 1
var score = 0
var theme
# Called when the node enters the scene tree for the first time.
func _ready():	
	$SignalMessageQueue.connect("met_died", self, "_on_met_died")
	$SignalMessageQueue.connect("hero_health_update", self, "_on_hero_health_update")
	add_child(met_spawner_timer)
	met_spawner_timer.connect("timeout", self, "_on_spawner_timeout")
	met_spawner_timer.start(1.5)
	## Get the user inputs
	ResourceLoader.load("res://users/")
	## Get all of the possible characte states
	ResourceLoader.load("res://characters/states/")
	## Instantiate hero
	if player_1 == "megaman":
		var megaman = MEGAMAN.instance()
		add_child(megaman)
		megaman.position = Vector2(100,400)
		theme = load("res://characters/heroes/megaman/sfx/theme.mp3")
	else:
		var Roll = ROLL.instance()
		add_child(Roll)
		Roll.position = Vector2(100,400)
	$AudioStreamPlayer2D.stream = theme
	$AudioStreamPlayer2D.play()
	## Instantiate first met
	var met = MET.instance()
	add_child(met)
	met.position = Vector2(800,400)
	$UserInterface/Score.text = str("Score: ", score)

func _on_hero_health_update(current_health, max_health):
	$UserInterface/HeroHealthBar.value = current_health
	$UserInterface/HeroHealthBar.max_value = max_health

func _on_met_died():
	met_count -= 1
	score += 5
	$UserInterface/Score.text = str("Score: ", score)

func _on_spawner_timeout():
	score += 1
	$UserInterface/Score.text = str("Score: ", score)
	if met_count < 3:
		var met = MET.instance()
		add_child(met)
		met.position = Vector2(800,400)
		met_count += 1
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
