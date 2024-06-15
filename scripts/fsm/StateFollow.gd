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
	
	var bodies = enemy.attack_area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("player"):
			state_machine.transition_to("StateAttack")
			return
	

