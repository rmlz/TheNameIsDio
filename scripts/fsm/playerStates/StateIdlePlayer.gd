class_name StateIdlePlayer
extends State

func enter(_msg:= {}) -> void:
	character.velocity = Vector2.ZERO
	character.animation_player.play("Idle")
	
func update(_delta: float) -> void:
	var input_vector: Vector2
	# Obter o input vector
	input_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down", 0.15)
	if Input.is_action_just_pressed("attack"):
		var dict = {"type": 1}
		dict.merge(character.inventory_component.items)
		state_machine.transition_to(
			"StateAttack", dict)
		return
	
	if input_vector.is_zero_approx():
		return
	
	state_machine.transition_to("StateWalk")
