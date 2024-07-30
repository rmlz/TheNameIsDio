class_name ProjectileBarrel
extends ProjectileBase

signal on_explosion_ends

func _physics_process(_delta):
	move_and_slide()
	
func start_explosion():
	$Explosions.show()
	var explosion_time_range = 0.3
	for item: AnimatedSprite2D in $Explosions.get_children():
		item.play("default")
		_do_damage()
		await get_tree().create_timer(explosion_time_range).timeout
		explosion_time_range -= 0.05
		
func end_animation():
	on_explosion_ends.emit()
	queue_free()
	
