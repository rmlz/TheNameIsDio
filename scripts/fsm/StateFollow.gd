class_name StateFollow
extends State


func enter(_msg:= {}) -> void:
	enemy.animation_player.play("Walk")
	
func update(delta: float) -> void:
	var player_position = GameManager.player_position
	var difference = player_position - enemy.position
	var input_vector = difference.normalized()

	rotate_sprite(input_vector)
	enemy.velocity = input_vector * enemy._speed * 100
	enemy.move_and_slide()
	
	var type_attack = enemy.is_range_to_attack_player()
	
	if type_attack == 1 or type_attack == 2:
		state_machine.transition_to("StateAttack", {"type": type_attack})
		
		
	
	

