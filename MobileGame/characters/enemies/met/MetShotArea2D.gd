extends Node2D

class_name MetShot

const SPEED = 300
var velocity = Vector2()
var direction = 1

onready var on_screen = $MetShot/VisibilityNotifier2D
# Called when the node enters the scene tree for the first time.
func _ready():
	on_screen.connect("screen_exited", self, "_on_screen_exited")
	print("met firing")

func set_shot_direction(dir):
	direction = dir

func _on_screen_exited():
	print("met shot disappeared")
	self.queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity.x = SPEED * delta * direction
	translate(velocity)
	
