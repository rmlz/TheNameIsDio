class_name StateKeepDistance
extends State

var return_idle_distance: int

func enter(_msg:= {}) -> void:
	enemy.animation_player.play("Walk")
	return_idle_distance = _msg["return_idle_distance"]
	
func update(delta: float) -> void:
	var player_position = GameManager.player_position
	var difference = enemy.position - player_position
	var input_vector = difference.normalized()

	rotate_sprite(input_vector)
	enemy.velocity = input_vector * enemy._speed * 100
	enemy.move_and_slide()
	
	var player_enemy_distance = player_position.distance_to(enemy.position)
	if return_idle_distance and return_idle_distance <= player_enemy_distance:
		state_machine.transition_to("StateIdle")
	

