extends Ritual
class_name RitualWind
	
func deal_damage() -> void:
	for body in damage_area.get_overlapping_bodies():
		if body.is_in_group("enemies"):
			var enemy: EnemyBase = body
			var max_push = 5
			var vector_to_player = (enemy.position - GameManager.player_position)
			var distance_to_player = enemy.position.distance_to(GameManager.player_position)
			var collision_vector = vector_to_player.normalized() * max(0, max_push  - distance_to_player / 200) 

			enemy.receive_damage_ignore_tanking(damage, collision_vector, 1)
			apply_status(enemy)
