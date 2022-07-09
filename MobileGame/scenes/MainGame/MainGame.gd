extends Node2D

#var player_1 = "Megaman"
onready var player_1 = PersistentData.player_1

const PROTOMAN = preload("res://characters/heroes/protoman/Protoman.tscn")
const MEGAMAN = preload("res://characters/heroes/megaman/Megaman.tscn")
const ROLL = preload("res://characters/heroes/roll/Roll.tscn")
const MET = preload("res://characters/enemies/met/Met.tscn")
var max_met_count = 3
var met_spawner_timer = Timer.new()
var met_spawn_location = RandomNumberGenerator.new()
var met_spawn_x: int
var met_spawn_y: int
var met_count = 1
var score = 0
var theme
# Called when the node enters the scene tree for the first time.
func _ready():	
	add_child(met_spawner_timer)
	met_spawner_timer.connect("timeout", self, "_on_spawner_timeout")
	met_spawner_timer.start(1.5)
	## Get the user inputs
	ResourceLoader.load("res://characters/states/")
	## Instantiate hero
	var megaman = PROTOMAN.instance()
	$YSort.add_child(megaman)
	megaman.position = Vector2(100,400)
	theme = load("res://characters/heroes/megaman/sfx/theme.mp3")

	$AudioStreamPlayer2D.stream = theme
	$AudioStreamPlayer2D.play()
