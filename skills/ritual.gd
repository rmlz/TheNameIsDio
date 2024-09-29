class_name Ritual
extends Node2D

@export var damage: int = 2
@export var status: PackedScene
@onready var damage_area = $Area2D

signal on_enemy_group_hitten

var status_scene: Status

func deal_damage() -> void:
	var play_audio = true
	var hitten_enemies = damage_area.get_overlapping_bodies().filter(
		func(body):
			return body.is_in_group("enemies")
	)
	for enemy: EnemyBase in hitten_enemies:
		enemy.receive_damage(damage, (enemy.position - GameManager.player_position).normalized())
		apply_status(enemy)
	on_enemy_group_hitten.emit(hitten_enemies)
	
func apply_status(enemy: EnemyBase) -> void:
	if status:
		status_scene = status.instantiate()
	if status_scene and not enemy.is_queued_for_deletion():
		enemy.status_component.add_status(status_scene, enemy)
		
func animate():
	pass
