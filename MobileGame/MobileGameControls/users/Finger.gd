extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _input(event):
	if event is InputEventScreenTouch && event.is_pressed():
		self.position = event.position
	elif event is InputEventScreenTouch && event.is_pressed() == false:
		#print("ALL BODIES TOUCHED = ", self.get_overlapping_bodies())
		pass	
