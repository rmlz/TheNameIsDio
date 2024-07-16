class_name StateKeepDistance
extends State

var return_idle_distance: int

func enter(_msg:= {}) -> void:
	character.animation_player.play("Walk")
	return_idle_distance = _msg["return_idle_distance"]
	
func update(_delta: float) -> void:
	var player_position = GameManager.player_position
	var difference = character.position - player_position
	var input_vector = difference.normalized()

	rotate_sprite(input_vector)
	character.velocity = input_vector * character._speed * 100
	character.move_and_slide()
	
	var player_enemy_distance = player_position.distance_to(character.position)
	if return_idle_distance and return_idle_distance <= player_enemy_distance:
		state_machine.transition_to("StateIdle")
	

