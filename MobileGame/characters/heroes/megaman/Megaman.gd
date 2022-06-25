# Megaman.gd

extends Character

class_name Megaman

onready var finger = get_tree().get_root().get_node("Main/Finger")
onready var tapper = get_tree().get_root().get_node("Main/Finger/Tapper")
onready var signal_message_queue = get_tree().get_root().get_node("Main/SignalMessageQueue")

func _ready():
	character_name = "megaman"
	character_type = "heroes"
	dash_attack_damage = 10
	jab_damage = 3
	special_attack_damage = 20
	## Get character states
	state_factory = StateFactory.new()
	change_state("neutral")
	tapper.connect("timeout", self, "_on_tapper_timeout")
	print("Megaman info: ", self)
	signal_message_queue.connect("hit", self, "_on_character_attacked")
	signal_message_queue.connect("enemy_jabbed", self, "_on_enemy_jabbed")
	signal_message_queue.connect("enemy_special_attacked", self, "_on_enemy_special_attacked")
	signal_message_queue.connect("enemy_tapped", self, "_on_enemy_tapped")
	signal_message_queue.connect("enemy_thrown", self, "_on_enemy_thrown")
	add_child(jab_window)
	jab_window.set_one_shot(true)

func _on_enemy_thrown(hero, enemy, throw_direction):
	if state.state_name() == "NeutralState" || state.state_name() == "WalkingState":
		if hero == (self):
			target_position = self.global_position
			currently_attacking = enemy
			attack_damage = dash_attack_damage
			if throw_direction == "right":
				target_position.x = (self.global_position.x + 100)
			change_state("throwing")

func _on_enemy_tapped(hero, enemy):
	if hero == (self):
		currently_attacking = enemy
		if state.state_name() == "RunningState":
			attack_damage = dash_attack_damage
			change_state("dash_attack")
			
func _on_enemy_special_attacked(hero, enemy):
	if hero == (self):
		attack_damage = jab_damage
		currently_attacking = enemy
		## If currently jabbing, continue jabbing
		if state.state_name() == "Jab_1_State" && jab_window.time_left != 0:
			change_state("jab_2")
			jab_window.start(0.5)
		elif state.state_name() == "Jab_2_State" && jab_window.time_left != 0:
			change_state("jab_3")
		else:
			attack_damage = special_attack_damage
			change_state("special")

func _on_enemy_jabbed(hero, enemy):
	if hero == (self):
		currently_attacking = enemy
		## If not dash attacking, then jab
		if state.state_name() != "DashAttackState" || state.state_name() != "ThrowingState":
			attack_damage = jab_damage
			if state.state_name() == "Jab_1_State" && jab_window.time_left != 0:
				change_state("jab_2")
				jab_window.start(0.5)
			elif state.state_name() == "Jab_2_State" && jab_window.time_left != 0:
				change_state("jab_3")
			else:
				change_state("jab_1")
				jab_window.start(0.5)

## If the player was hit
func _on_character_attacked(from, to, amount_of_damage):
	if to == (self):
		print("Megaman was hit by ", from)
		print("Damage taken:", amount_of_damage)

func _input(event):
	if event is InputEventScreenTouch && event.is_pressed():
		finger_on_screen = true
			#signal_message_queue.emit_signal("hit", self, $MegaManPivotPoint/JabRange.get_overlapping_bodies(), 20)
	## If the player's finger is released from the screen
	if event is InputEventScreenTouch && event.is_pressed() == false:
		if attacks.has(state.state_name()) == false:
			finger_on_screen = false
			## If the player swiped (finger not where it started)
			if event.position != target_position:
				## Set target position
				target_position = event.position
				## If the player touched the character before lifting their finger (dragging the characer in a direction)
				if finger.overlaps_area(self.get_node("Sprite/SpriteArea2D")):
					## If dragging up
					if self.position.y - event.position.y > 30:
						attack_damage = jab_damage
						change_state("jumping")
					## If dragging down
					elif self.position.y - event.position.y < -50 && abs(self.position.x - event.position.x) < 200:
						if state.state_name() == "NeutralState":
							change_state("taunting")
					## If dragging sideways
					elif abs(self.position.x - event.position.x) > 100:
						change_state("rolling")

## If the player tapped the screen		
func _on_tapper_timeout():
	tap_count = tapper.tap_count
	print("Tap count: ", tap_count)
	if state.state_name() == "NeutralState" || state.state_name() == "WalkingState" || state.state_name() == "RunningState":
		## Don't transition from landing attack to walking
		if state.state_name() != "LandingAttackState":
			## If the player didn't tap the character
			if finger.overlaps_area(self.get_node("Sprite/SpriteArea2D")) == false:
				## If player is not currently attacking
				if attacks.has(state.state_name()) == false:
					if tap_count == 1:
						change_state("walking")
					else:
						change_state("running")
				else: ## If the player is currently attacking
					print("can't move, currently attacking")
			## If the player tapped and held the character
			else:
				## Can only block from a neutral states
				if state.state_name() == "NeutralState" && finger_on_screen == true:
					change_state("blocking")
			
