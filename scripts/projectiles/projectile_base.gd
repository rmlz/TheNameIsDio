class_name ProjectileBase
extends CharacterBody2D

@onready var damage_area = $DamageArea
@onready var sprite = $Sprite2D

@export var speed: float = 300
@export var bump_ground_reduce_speed: float = 0.8
@export var damage: int = 10
@export var friend_fire: bool = true

var start_point: Vector2
var end_point: Vector2
var actual_velocity: Vector2
var number_of_bumps = 0
var max_distance = 0.0

func _ready():
	$Explosion.visible = false
	damage = 25

func _move_project() -> void:
	pass

func _physics_process(delta):
	_move_project()
	
func _do_damage():
	for body in damage_area.get_overlapping_bodies():
		if body.is_in_group("player"):
			var player: PlayerObject = body
			var push_vector = (player.position - position).normalized() * 5
			player.get_hit(damage, push_vector)
		if body.is_in_group("enemies") and friend_fire:
			var enemy: EnemyBase = body
			var push_vector = (enemy.position - position).normalized() * 5
			enemy.damage(damage, push_vector, true)
	queue_free()
	
func calculate_movement():
	pass

func setup(start: Vector2, end: Vector2, probable_max_distance):
	pass
