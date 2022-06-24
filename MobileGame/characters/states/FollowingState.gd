# walking_state.gd

extends State

class_name FollowingState

var currently_following

func _ready():
	state_name = "FollowingState"
	#print(state_name, " instantiated")
	sprite.texture = load("res://characters/%s/%s/sprites/walking.png" %[character_type, character_name])
	currently_following = currently_attacking
	speed = 300
	## Face left if moving left
	if persistent_state.global_position.x - target_position.x > 0:
		sprite.scale.x = -1
	else:
		sprite.scale.x = 1
	
	print(persistent_state.character_name, " is currently following: ", currently_following)

func _physics_process(_delta):
	if persistent_state.global_position.x - currently_following.global_position.x < 0: ## Be on the left side
		print("left")
		target_position = Vector2((currently_following.global_position.x - 200), (currently_following.global_position.y))
	else:
		print("right")
		target_position = Vector2((currently_following.global_position.x + 200), (currently_following.global_position.y))

	velocity = persistent_state.global_position.direction_to(target_position) * speed
	persistent_state.velocity = (velocity)
	if persistent_state.global_position.distance_to(target_position) <= 5:
		change_state.call_func("blocking")
