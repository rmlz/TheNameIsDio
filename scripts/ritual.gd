extends Node2D


@export var damage: int = 2

@onready var damage_area = $Area2D

func deal_damage() -> void:
	for body in damage_area.get_overlapping_bodies():
		if body.is_in_group("enemies"):
			var enemy: EnemyBase = body
			enemy.receive_damage(damage, (enemy.position - GameManager.player_position).normalized())
	pass
