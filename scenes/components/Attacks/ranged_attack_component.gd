class_name RangedAttackComponent
extends Node2D

@onready var attack_area = $AttackArea
@export var number_of_projectiles := 1
@export var projectile_scene: PackedScene
var enemy: EnemyBase

func _ready():
	await(owner._ready())
	enemy = owner
	
func attack(target_position: Vector2) -> void:
	var projectile_instance: Node
	for i in range(number_of_projectiles):
		projectile_instance = projectile_scene.instantiate() as ProjectileBase
		projectile_instance.setup(enemy.launch_point.global_position, target_position, 750, enemy.animated_sprite.flip_h)
		owner.get_parent().add_child(projectile_instance)
