@tool
class_name BaseMeleeAttackComponent
extends Node2D

var attack_area: Area2D
var character: CharacterBase
var target: CharacterBase

@export var attack_shape: Shape2D

func _ready():
	assert(attack_shape)
	attack_area = $AttackArea
	var collision_shape = attack_area.get_node(
		"CollisionShape") as CollisionShape2D
	
	collision_shape.shape = attack_shape
	await owner.ready
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
		var attack_direction: Vector2
		if character.animated_sprite.flip_h:
			attack_direction = Vector2.LEFT
		else:
			attack_direction = Vector2.RIGHT
		var dot_product = direction_to_target.dot(attack_direction)
		if is_range_attack() and dot_product >= 0.1:
			target.receive_damage(character._hit_damage, direction_to_target)
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
					enemy.receive_damage(character._hit_damage, direction_to_enemy)

func _get_configuration_warnings():
	if not attack_area:
		return ["The attack shape cannot be null"]
