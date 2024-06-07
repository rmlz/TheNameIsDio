class_name Collectable
extends Node

@export var health_regen = 10
@export var points = 1000

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		on_collect(body)

func on_collect(player: PlayerObject) -> void:
	player.health = min(player.health + health_regen, player.max_health)
	GameManager.points += points
	queue_free()



