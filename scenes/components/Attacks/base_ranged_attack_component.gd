class_name BaseRangedAttackComponent
extends Node2D

@onready var attack_area = $AttackArea
@export var number_of_projectiles := 1
@export var projectile_scene: PackedScene

var character: CharacterBase

func _ready():
	await(owner._ready())
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
		projectile_instance.setup(character.launch_point.global_position, target_position, 750)
		owner.get_parent().add_child(projectile_instance)
