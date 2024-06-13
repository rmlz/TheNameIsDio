extends EnemyBase

@export var project_scene: PackedScene
@export var number_of_projects: int = 1
@export var throw_radius: float = 0.0
@export var walk_cooldown: float = 0.0
var _walk_cooldown: float = 0.0


func deal_damage(delta: float) -> void:
	if _deal_damage_cooldown > 0:
		_deal_damage_cooldown -= delta
	if _walk_cooldown > 0:
		velocity = Vector2.ZERO
		_walk_cooldown -= delta
		return
	if _is_damage_animation:
		return
	$AnimatedSprite2D.play("throw")
	var bodies = attack_area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("player"):
			var player: PlayerObject = body
			var direction_to_player = (player.position - global_position).normalized()
			throw_project(player.position)
			_deal_damage_cooldown = _deal_damage_time_cooldown
			_walk_cooldown = walk_cooldown
			


func throw_project(player_position: Vector2) -> void:
	for i in range(number_of_projects):
		var projectile_instance: ProjectilDynamite = project_scene.instantiate()
		projectile_instance.setup($LaunchStartPoint.global_position, player_position, 750)
		get_parent().add_child(projectile_instance)


func _on_throw_animation_finished():
	$AnimatedSprite2D.play("walk")
