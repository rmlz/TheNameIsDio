class_name GoblinBarrel
extends EnemyBase

var is_explosion_animation_ended: bool = false

func proccess_attack(target_position: Vector2, type: int) -> void:
	hide()
	collision_layer = pow(2, 10-1) #change collision layer to 32 
	var barrel_instance: ProjectileBarrel = ranged_attack_component.projectile_scene.instantiate()
	barrel_instance.position = position + Vector2(0, -20)
	barrel_instance.on_explosion_ends.connect(func():
		is_explosion_animation_ended = true
		die()
		)
	get_parent().add_child(barrel_instance)


func die() -> void:
	if not is_explosion_animation_ended:
		proccess_attack(global_position, 2)
	else:
		if death_prefab:
			var death_object = death_prefab.instantiate()
			death_object.position = position
			get_parent().add_child(death_object)
		drop_items_component.drop_items()
		GameManager.change_monster_spawn_number_by(-1)
		queue_free()
