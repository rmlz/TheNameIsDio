extends CanvasLayer

var last_int = 0

func _ready():
	var points_label: Label = $PointsLabel
	points_label.text = "Dio has done %09d points" % [GameManager.points]
	
	
func _process(delta):
	if (int(delta) > last_int):
		last_int = int(delta)
		GameManager.player_position += Vector2(randi_range(-300, 300), randi_range(-300, 300))
		
	
