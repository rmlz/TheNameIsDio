class_name ProjectileArrow
extends ProjectileBase

var _over_z_index = false

func _set_over_z_index(value: bool) -> void:
	_over_z_index = value

func _physics_process(_delta):
	move_and_slide()
	_do_damage()
	
func _do_damage():
	if velocity == Vector2.ZERO or _over_z_index:
		return
	for body in damage_area.get_overlapping_bodies():
		if body.is_in_group("player"):
			var player: PlayerObject = body
			var push_vector = (player.position - position).normalized() * 5
			player.receive_damage(damage, push_vector)
			queue_free()
			return
