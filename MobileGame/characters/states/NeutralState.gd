# idle_state.gd

extends State

class_name NeutralState

func _ready():
	state_name = "NeutralState"
	#print(state_name, " instantiated")
	sprite.texture = load("res://characters/%s/%s/sprites/neutral.png" %[character_type, character_name])

func _physics_process(_delta):
	velocity = position.direction_to(self.position) * 200
	persistent_state.velocity = (velocity)
