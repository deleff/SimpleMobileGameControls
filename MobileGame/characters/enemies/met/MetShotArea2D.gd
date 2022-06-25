extends Node2D

class_name MetShot

const SPEED = 300
var velocity = Vector2()
var x_direction: int
var y_direction: int
var hit_direction: String
onready var signal_message_queue = get_tree().get_root().get_node("Main/SignalMessageQueue")
onready var on_screen = $MetShot/VisibilityNotifier2D
onready var hitbox = $MetShot
# Called when the node enters the scene tree for the first time.
func _ready():
	signal_message_queue.connect("hurtbox_entered", self, "_on_hero_hit")
	on_screen.connect("screen_exited", self, "_on_screen_exited")
	hitbox.connect("area_entered", self, "_on_hit_something")

func _on_hero_hit(hero, hit_by):
	if hit_by == $MetShot:
		if x_direction == -1:
			hit_direction = "left"
		else:
			hit_direction = "right"
		signal_message_queue.emit_signal("hit", self, hero, "met_shot", 10, hit_direction)
		self.queue_free()

func set_shot_direction(x, y):
	x_direction = x
	y_direction = y

func _on_screen_exited():
	self.queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity.x = SPEED * delta * x_direction
	velocity.y = SPEED * delta * y_direction
	translate(velocity)
	
