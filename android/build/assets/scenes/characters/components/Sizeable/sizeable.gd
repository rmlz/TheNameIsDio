class_name SizeChanger
extends Node

enum Sizes {SMALLEST, SMALL, REGULAR, BIG, BIGGEST}
var enemy: EnemyBase
	
func get_scale_vector(size: Sizes) -> Vector2:
	match size:
		Sizes.SMALLEST:
			return Vector2(0.5, 0.5)
		Sizes.SMALL:
			return Vector2(0.75, 0.75)
		Sizes.REGULAR:
			return Vector2(1,1)
		Sizes.BIG:
			return Vector2(2,2)
		Sizes.BIGGEST:
			return Vector2(3,3)
		_: #default
			return Vector2(1, 1)
