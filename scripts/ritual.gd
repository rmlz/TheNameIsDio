extends Node2D


@export var damage: int = 2

@onready var damage_area = $Area2D

func deal_damage() -> void:
	for body in damage_area.get_overlapping_bodies():
		if body.is_in_group("enemies"):
			var enemy: EnemyBase = body
			enemy.damage(damage, (GameManager.player_position - enemy.position).normalized())
	pass
