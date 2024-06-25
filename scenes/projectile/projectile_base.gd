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
var movement_direction: Vector2

func _move_project() -> void:
	pass

func _physics_process(_delta):
	_move_project()
	
func _do_damage():
	for body in damage_area.get_overlapping_bodies():
		if body.is_in_group("player"):
			var player: PlayerObject = body
			var push_vector = (player.position - position).normalized() * 5
			player.get_hit(damage, push_vector)
			queue_free()

func bump_projectile_to_ground():
	pass
	
func calculate_movement():
	velocity = movement_direction * speed * (1 - bump_ground_reduce_speed) ** number_of_bumps
	actual_velocity = velocity

func setup(start: Vector2, end: Vector2, probable_max_distance):
	position = start
	start_point = start
	end_point = end
	max_distance = probable_max_distance
	var razao = end_point.distance_to(start_point) / max_distance
	movement_direction = (end_point - start_point).normalized() * razao
	if (absf(movement_direction.x) > absf(movement_direction.y)):
		if movement_direction.x > 0:
			$MovementAnimation.play("Throw_Right")
		else:
			$MovementAnimation.play("Throw_Left")
	else:
		if movement_direction.y > 0:
			$MovementAnimation.play("Throw_Down")
		else:
			$MovementAnimation.play("Throw_Up")
	
	calculate_movement()

func stop_velocity():
	velocity = Vector2.ZERO
