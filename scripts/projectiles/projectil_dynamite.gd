class_name ProjectilDynamite
extends ProjectileBase

func _ready():
	$Explosion.visible = false
	damage = 25

func _move_project() -> void:
	var total_distance = end_point.distance_to(start_point)
	var actual_distance = position.distance_to(end_point)
	calculate_movement()
	move_and_slide()

func _physics_process(delta):
	_move_project()

func start_explosion():
	$Explosion.visible = true
	$Explosion.play("default")
	
func _do_damage():
	for body in damage_area.get_overlapping_bodies():
		if body.is_in_group("player"):
			var player: PlayerObject = body
			var push_vector = (player.position - position).normalized() * 5
			player.get_hit(damage, push_vector)
		if body.is_in_group("enemies"):
			var enemy: EnemyBase = body
			var push_vector = (enemy.position - position).normalized() * 5
			enemy.damage(damage, push_vector, true)
	queue_free()
	
func calculate_movement():
	var razao = end_point.distance_to(start_point) / max_distance
	var direction: Vector2 = (end_point - start_point).normalized() * razao
	velocity = direction * speed * (1 - bump_ground_reduce_speed) ** number_of_bumps
	actual_velocity = velocity
	
func bump_projectile_to_ground():
	number_of_bumps += 1

func setup(start: Vector2, end: Vector2, probable_max_distance):
	position = start
	start_point = start
	end_point = end
	max_distance = probable_max_distance
	calculate_movement()
