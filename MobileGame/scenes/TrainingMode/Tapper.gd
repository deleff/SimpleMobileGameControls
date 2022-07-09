extends Timer

# Declare member variables here. Examples:
var last_tap_location = Vector2()
var tap_location = Vector2() setget , get_tap_location
var tap_entered_location
var tap_exited_location
var tap_released = false
var tap_count = 0 setget , get_tap_count

# Called when the node enters the scene tree for the first time.
func _ready():
	self.set_one_shot(true)

func _input(event):
	if event is InputEventScreenTouch && event.is_pressed():
		tap_entered_location = event.position
		_tap_counter()
		if tap_location != null:
			last_tap_location = tap_location
		else:
			tap_location = last_tap_location
	elif event is InputEventScreenTouch && event.is_pressed() == false:
		tap_exited_location = event.position
		if self.time_left > 0:
			if tap_entered_location == tap_exited_location:
				tap_location = event.position

func _tap_counter():
	if self.time_left == 0:
		self.start(0.3)
		tap_count = 1
	else:
		tap_count += 1

func get_tap_location():
	return tap_location

func get_tap_count():
	return tap_count
