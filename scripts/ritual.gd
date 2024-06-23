class_name Ritual
extends Node2D


@export var damage: int = 2
@export var status: PackedScene
@onready var damage_area = $Area2D

var status_scene: Status

func deal_damage() -> void:
	for body in damage_area.get_overlapping_bodies():
		if body.is_in_group("enemies"):
			var enemy: EnemyBase = body
			enemy.receive_damage(damage, (enemy.position - GameManager.player_position).normalized())
			apply_status(enemy)
	pass
	
func apply_status(enemy: EnemyBase):
	if status:
		status_scene = status.instantiate()
	if status_scene and not enemy.is_queued_for_deletion():
		enemy.status_component.add_status(status_scene, enemy)
		
