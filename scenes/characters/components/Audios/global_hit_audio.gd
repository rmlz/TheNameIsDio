class_name GlobalHitAudio extends Node2D

func play_hit_audio(enemies: Array, player_pos: Vector2) -> void:
	var distance = 999999999999
	var is_tank = false
	var pos = Vector2.ZERO
	for enemy: EnemyBase in enemies:
		var distance_to_player = enemy.position.distance_to(player_pos)
		if distance_to_player < distance:
			distance = distance_to_player
			is_tank = enemy.statistics.get_hit_cooldown_secs == 0 or enemy.invicible	
			pos = enemy.position
	
	self.position = pos
	if is_tank and not $TankAudio.playing:
		$TankAudio.play(0)
	if not is_tank and not $HitAudio.playing:
		$HitAudio.play(0)


func _on_player_on_attack_enemy_group(enemies: Array, player_pos: Vector2) -> void:
	play_hit_audio(enemies, player_pos)
