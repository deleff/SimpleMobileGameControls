# Megaman.gd

extends Character

class_name megaman

func _ready():
	signal_message_queue = get_tree().get_root().get_node("MainGame/SignalMessageQueue")
	character_name = "megaman"
	character_type = "heroes"
	dash_attack_damage = 13
	jab_damage = 3
	special_attack_damage = 20
	throw_damage = 15
	audio = $AudioStreamPlayer2D
	## Get character states
	state_factory = StateFactory.new()
	change_state("neutral")
	add_child(jab_window)
	jab_window.set_one_shot(true)
	hurtbox = $Sprite/SpriteArea2D
	hurtbox.connect("area_entered", self, "on_hutbox_entered")
	max_health = 100
	current_health = max_health
	var start_sound = load("res://characters/heroes/megaman/sfx/instantiated.wav")
	audio.stream = start_sound
	audio.play()
	
func _input(event):
	if event is InputEventScreenTouch && event.is_pressed():
		change_state("taunting")
