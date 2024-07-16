class_name Collectable
extends AnimatedSprite2D

@export var health_regen = 10
@export var points = 1000

func _ready():
	_animate_light()
	
func _animate_light():
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
		on_collect(body)

func on_collect(player: PlayerObject) -> void:
	player.health.heal(health_regen)
	player.collect_audio.play()
	GameManager.points += points
	queue_free()



