class_name MeleeAttackComponent
extends Node2D

@onready var attack_area = $AttackArea
var enemy: EnemyBase

func _ready():
	await(owner._ready())
	enemy = owner
	
func attack(target_position: Vector2) -> bool:
	var bodies = attack_area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("player"):
			var player: PlayerObject = body
			var direction_to_player = (target_position - position).normalized()
			player.get_hit(enemy.hit_damage, direction_to_player)
			return true
	return false
