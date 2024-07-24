extends CanvasLayer

signal on_button_buy_clicked

func _ready():
	$PanelPoints/Points.text = "Points: %09d" % [GameManager.get_points()]
	GameManager.on_change_points.connect(_on_points_changed)
	$PanelTime/Time.text = "Time: %02d:%02d" % [GameManager.max_game_time, 0]
	GameManager.on_change_time_left.connect(_on_time_changed)
	$DebugPanelMonsters.visible = GameManager.is_debug_enabled
	if (GameManager.is_debug_enabled):
		GameManager.on_change_spawn_number.connect(_on_monster_spawned_number_changed)
		

func _on_monster_spawned_number_changed(new_number_monster_spawned: int):
	$DebugPanelMonsters/NumberMonsters.text = "Monsters:\n%03d" % new_number_monster_spawned

func _on_points_changed(new_points: int):
	$PanelPoints/Points.text = "Points: %09d" % [new_points]
	
func _on_time_changed(new_time_left: float):
	var sec = fmod(new_time_left, 60.0)
	var min = int(new_time_left / 60)
	$PanelTime/Time.text = "Time: %02d:%02d" % [min, sec]

func _on_button_buy_pressed():
	on_button_buy_clicked.emit()
