class_name StateFollow
extends State


func enter(_msg:= {}) -> void:
	character.animation_player.play("Walk")
	
func update(delta: float) -> void:
	var player_position = GameManager.player_position
	var difference = player_position - character.position
	var input_vector = difference.normalized()

	rotate_sprite(input_vector)
	character.velocity = input_vector * character._speed * 100
	character.move_and_slide()
	
	var type_attack = character.is_range_to_attack_player()
	
	if type_attack == 1 or type_attack == 2:
		state_machine.transition_to("StateAttack", {"type": type_attack})
		
		
	
	

