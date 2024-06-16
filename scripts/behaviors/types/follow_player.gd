class_name BehaviorFollowPlayer
extends BehaviorBase


func _physics_process(delta: float) -> void:
	var player_position = GameManager.player_position
	var difference: Vector2
	var input_vector: Vector2
	
	if enemy.update_damage_animation(delta):
		enemy.velocity = lerp(enemy.velocity, Vector2.ZERO, 0.05)
	else:
		enemy.end_damage_animation()
		difference = player_position - enemy.position
		input_vector = difference.normalized()
		rotate_sprite(input_vector)
		enemy.velocity = input_vector * enemy._speed * 100
	
	enemy.deal_damage(delta)
	enemy.move_and_slide()
