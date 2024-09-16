class_name Ritual
extends Node2D

@export var damage: int = 2
@export var status: PackedScene
@onready var damage_area = $Area2D

var status_scene: Status

func deal_damage() -> void:
	var play_audio = true
	for body in damage_area.get_overlapping_bodies():
		if body.is_in_group("enemies"):
			var enemy: EnemyBase = body
			if play_audio:
				enemy.receive_damage_play_audio(damage, (enemy.position - GameManager.player_position).normalized())
			else:
				enemy.receive_damage(damage, (enemy.position - GameManager.player_position).normalized())
			apply_status(enemy)
	
func apply_status(enemy: EnemyBase) -> void:
	if status:
		status_scene = status.instantiate()
	if status_scene and not enemy.is_queued_for_deletion():
		enemy.status_component.add_status(status_scene, enemy)
		
func animate():
	pass
