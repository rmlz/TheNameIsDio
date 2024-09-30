@tool
class_name BaseMeleeAttackComponent
extends Node2D

var attack_area: Area2D
var character: CharacterBase
var target: CharacterBase

@export var attack_shape: Shape2D

signal enemy_group_hitten

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
		var hitten_enemies = attack_area.get_overlapping_bodies().filter(
			func(body):
				return body.is_in_group("enemies") and _calculate_dot_product(body, )
		)
		for enemy: EnemyBase in hitten_enemies :
			var direction_to_enemy = (enemy.position - character.position).normalized()
			enemy.receive_damage(character._hit_damage, direction_to_enemy)
			
		enemy_group_hitten.emit(hitten_enemies)

func _calculate_dot_product(enemy: EnemyBase) -> bool:
	var direction_to_enemy = (enemy.position - character.position).normalized()
	var attack_direction: Vector2
	if character.animated_sprite.flip_h:
		attack_direction = Vector2.LEFT
	else:
		attack_direction = Vector2.RIGHT
	var dot_product = direction_to_enemy.dot(attack_direction)
	return dot_product >= 0.1

func _get_configuration_warnings():
	if not attack_area:
		return ["The attack shape cannot be null"]
