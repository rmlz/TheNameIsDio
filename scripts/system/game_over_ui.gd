extends CanvasLayer

@export var restart_delay: int = 5


var restart: float = 0.0
var last_int = 0
var initial_screen: PackedScene

func _ready():
	restart = restart_delay
	last_int = restart_delay
	initial_screen = preload("res://misc/system/game_start.tscn")
	var points_label: Label = $PointsLabel
	points_label.text = "Dio has done %09d points" % [GameManager.points]
	
	
func _process(delta):
	restart -= delta
	if (int(restart) < last_int - 1):
		last_int = int(restart)
		GameManager.player_position += Vector2(randi_range(-300, 300), randi_range(-300, 300))
	if restart <= 0:
		get_tree().change_scene_to_packed(initial_screen) 
		GameManager.reset()
		
	
