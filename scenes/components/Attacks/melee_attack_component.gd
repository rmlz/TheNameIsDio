class_name MeleeAttackComponent
extends Node2D

@onready var attack_area = $AttackArea
var enemy: EnemyBase
var target: PlayerObject

func _ready():
	await(owner._ready())
	enemy = owner
	
func is_range_attack_player() -> bool:
	for body in attack_area.get_overlapping_bodies():
		if body.is_in_group("player"):
			target = body as PlayerObject
			return true
	
	return false
	
func attack(target_position: Vector2) -> void:
	var direction_to_player = (target_position - enemy.position).normalized()
	if is_range_attack_player():
		target.get_hit(enemy.hit_damage, direction_to_player)
	target = null
