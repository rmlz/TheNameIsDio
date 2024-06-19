class_name BaseMeleeAttackComponent
extends Node2D

var attack_area: Area2D
var character: CharacterBase
var target: CharacterBase

func _ready():
	attack_area = $AttackArea
	await(owner._ready())
	character = owner
	
func is_range_attack() -> bool:
	if character is EnemyBase:
		for body in attack_area.get_overlapping_bodies():
			if body.is_in_group("player"):
				target = body as PlayerObject
				return true
	return false
	
func attack(target_position: Vector2) -> void:
	if character is EnemyBase:
		assert(target_position != null)
		var direction_to_target = (target_position - character.position).normalized()
		if is_range_attack():
			target.receive_damage(character.hit_damage, direction_to_target)
		target = null
	elif character is PlayerObject:
		for body in attack_area.get_overlapping_bodies():
			if body.is_in_group("enemies"):
				var enemy: EnemyBase = body
				var direction_to_enemy = (enemy.position - character.position).normalized()
				var attack_direction: Vector2
				if character.animated_sprite.flip_h:
					attack_direction = Vector2.LEFT
				else:
					attack_direction = Vector2.RIGHT
				var dot_product = direction_to_enemy.dot(attack_direction)
				if dot_product >= 0.1:
					enemy.receive_damage(character.hit_damage, direction_to_enemy)
