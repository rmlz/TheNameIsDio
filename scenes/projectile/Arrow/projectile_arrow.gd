class_name ProjectileArrow
extends ProjectileBase

func _physics_process(_delta):
	move_and_slide()
	_do_damage()
	
func _do_damage():
	if velocity == Vector2.ZERO:
		return
	for body in damage_area.get_overlapping_bodies():
		if body.is_in_group("player"):
			var player: PlayerObject = body
			var push_vector = (player.position - position).normalized() * 5
			player.receive_damage(damage, push_vector)
			queue_free()
			return
