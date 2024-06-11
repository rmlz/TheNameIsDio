class_name ProjectileBase
extends CharacterBody2D

var start_point: Vector2
var end_point: Vector2
var actual_velocity: Vector2
@export var speed: float = 300
@export var bump_ground_reduce_speed: float = 0.8
@export var damage: int = 10
var number_of_bumps = 0

func _move_project() -> void:
	pass

func _do_damage() -> void:
	pass
