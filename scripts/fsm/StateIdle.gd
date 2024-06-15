class_name StateIdle
extends State

@export_range(0, 9999, 10) var aggro_distance: int = 300
@export_range(0, 9999, 10) var keep_distance: int = 0

func enter(_msg:= {}) -> void:
	enemy.velocity = Vector2.ZERO
	enemy.animation_player.play("Idle")
	
func update(delta: float) -> void:
	var player_position = GameManager.player_position
	var difference: Vector2
	var input_vector: Vector2
	
	difference = player_position - enemy.position
	var player_enemy_distance = player_position.distance_to(enemy.position)
	if player_enemy_distance <= keep_distance:
		state_machine.transition_to("StateKeepDistance", {"return_idle_distance": keep_distance})
		return
	
	if player_enemy_distance <= aggro_distance:
		state_machine.transition_to("StateFollow")

