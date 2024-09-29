@tool
class_name BaseRangedAttackComponent
extends Node2D

@onready var attack_area = $AttackArea
@export var number_of_projectiles := 1

@export var projectile_scene: PackedScene
@export var attack_shape: Shape2D

var character: CharacterBase

func _ready():
	assert(attack_shape)
	var collision_shape = attack_area.get_node(
		"CollisionShape") as CollisionShape2D
	collision_shape.shape = attack_shape
	await owner.ready
	character = owner

func is_range_attack() -> bool:
	if character is EnemyBase:
		for body in attack_area.get_overlapping_bodies():
			if body.is_in_group("player"):
				return true
	elif character is PlayerObject:
		# Is it needed to put player logic here?
		return false
	return false
	
func attack(target_position: Vector2) -> void:
	var projectile_instance: Node
	for i in range(number_of_projectiles):
		projectile_instance = projectile_scene.instantiate() as ProjectileBase
		projectile_instance.setup(character.launch_point.global_position, generate_noisy_position(target_position), 750)
		owner.get_parent().add_child(projectile_instance)

func _get_configuration_warnings():
	var result: PackedStringArray = []
	if not attack_area:
		result.append("The attack shape cannot be null")
	if not projectile_scene:
		result.append("Projectile scene cannot be null")
	return result
	
func generate_noisy_position(target_position: Vector2, noise_level: float = 150.0)-> Vector2:
	var noise_x = randf_range(-noise_level, noise_level)
	var noise_y = randf_range(-noise_level, noise_level)
	
	return target_position + Vector2(noise_x, noise_y)
