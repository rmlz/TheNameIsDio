class_name DashGhost extends Sprite2D

func _ready() -> void:
	animate()
	
func animate() -> void:
	var tween = create_tween()
	tween.finished.connect(func(): 
		self.queue_free())
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property(
		self, "modulate", Color.TRANSPARENT, 0.3
	)
	
	
