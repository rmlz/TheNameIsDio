class_name StateWalkPlayer
extends State

func enter(_msg:= {}) -> void:
	character.animation_player.play("Walk")
	
func update(_delta: float) -> void:
	var input_vector: Vector2
	# Obter o input vector
	
	input_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down", 0.15)
	
	rotate_sprite(input_vector)
	character.velocity = input_vector * character._speed * 100
	character.move_and_slide()
	
	if Input.is_action_just_pressed("attack"):
		var dict = {"type": 1}
		dict.merge(character.inventory_component.items)
		state_machine.transition_to(
			"StateAttack", dict)
		return
	
	if Input.is_action_just_pressed("dash"):
		print("FINE")
		state_machine.transition_to(
			"StateDash"
		)
	
	if input_vector.is_zero_approx():
		state_machine.transition_to("StateIdle")
