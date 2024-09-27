class_name Collectable
extends AnimatedSprite2D

@export var health_regen = 10
@export var points = 1000
@export var time_secs = 30

func _ready():
	_animate_light()
	get_tree().create_timer(time_secs / 2).timeout.connect(
		func():
			var tween = get_tree().create_tween()
			tween.set_ease(Tween.EASE_IN)
			tween.set_trans(Tween.TRANS_QUINT)
			tween.tween_property(
				self, "modulate", Color.RED, time_secs/2
			)
			tween.finished.connect(
				func():
					var tween_2 = get_tree().create_tween()
					tween_2.set_ease(Tween.EASE_IN)
					tween_2.set_trans(Tween.TRANS_QUINT)
					tween_2.tween_property(
					self, "modulate", Color.TRANSPARENT, 0.5
			)
					await tween_2.finished
					queue_free()
			)
	)
	
func _animate_light():
	# TODO levar o timer abaixo para um único timer no GameManager
	await get_tree().create_timer(10).timeout
	var tween = create_tween()
	modulate.v = 15
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property(
		self, "modulate", Color.WHITE, 0.3
	)

	_animate_light()
	

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		if (body as PlayerObject).state_machine.current_state != "StateDash":
			on_collect(body)

func on_collect(player: PlayerObject) -> void:
	player.health.heal(health_regen)
	player.collect_audio.play()
	GameManager.change_points_by(points)
	queue_free()
