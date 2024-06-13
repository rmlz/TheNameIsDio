class_name BehaviorKeepDistance
extends BehaviorBase

@export var distance: int = 300
var dist_range_next: float = 1 * distance
var dist_range_far: float = 1.6 * distance

func _physics_process(delta: float) -> void:
	var player_position = GameManager.player_position
	var difference: Vector2
	var input_vector: Vector2
	
	if enemy.update_damage_animation(delta):
		enemy.velocity = lerp(enemy.velocity, Vector2.ZERO, 0.05)
	else:
		enemy.end_damage_animation()
		difference = player_position - enemy.position
		var player_enemy_distance = player_position.distance_to(enemy.position)
		
		if player_enemy_distance > dist_range_far:
			input_vector = difference.normalized()
			enemy.run_from_player = false
			print("FOLLOW")
		elif player_enemy_distance < dist_range_next:
			input_vector = (difference * -1).normalized()
			enemy.run_from_player = true
			print("RUN AWAY")
		else:
			input_vector = Vector2.ZERO
			enemy.run_from_player = false
			
		
		rotate_sprite(input_vector)
		enemy.velocity = input_vector * enemy._speed * 100
	if not enemy.run_from_player:
		enemy.deal_damage(delta)
	enemy.move_and_slide()
