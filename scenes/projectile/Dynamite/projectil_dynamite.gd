class_name ProjectilDynamite
extends ProjectileBase

func _ready():
	$Explosion.visible = false

func _move_project() -> void:
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
			player.receive_damage(damage, push_vector)
		if body.is_in_group("enemies") and friend_fire:
			var enemy: EnemyBase = body
			var push_vector = (enemy.position - position).normalized() * 5
			enemy.receive_damage(damage, push_vector, true)
	
func calculate_movement():
	velocity = movement_direction * speed * (1 - bump_ground_reduce_speed) ** number_of_bumps
	actual_velocity = velocity
	
func bump_projectile_to_ground():
	number_of_bumps += 1
