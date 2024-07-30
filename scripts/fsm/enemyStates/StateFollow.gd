class_name StateFollow
extends State

@export_range(0, 9999, 10) var charge_distance: int = 0

func enter(_msg:= {}) -> void:
	character.animation_player.play("Walk")
	
func update(_delta: float) -> void:
	var player_position = GameManager.player_position
	var distance_to_player = player_position.distance_to(character.position)
	if distance_to_player <= charge_distance:
		state_machine.transition_to("StateCharge")
		return
	var difference = player_position - character.position
	var input_vector = difference.normalized()

	rotate_sprite(input_vector)
	character.velocity = input_vector * character._speed * 100
	character.move_and_slide()
	
	var type_attack = character.is_range_to_attack_player()
	
	if type_attack == 1 or type_attack == 2:
		state_machine.transition_to("StateAttack", {"type": type_attack})
		
		
	
	

