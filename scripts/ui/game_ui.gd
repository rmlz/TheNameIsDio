extends Node

func _ready():
	$PanelPoints/Points.text = "Points: %09d" % [GameManager.points]
	$PanelTime/Time.text = "Time: %02d:%02d" % [GameManager.max_game_time, 0]
	$DebugPanelMonsters.visible = GameManager.is_debug_enabled
	
func _process(delta):
	$PanelPoints/Points.text = "Points: %09d" % [GameManager.points]
	var sec = fmod(GameManager.time_left, 60.0)
	var min = int(GameManager.time_left / 60)
	$PanelTime/Time.text = "Time: %02d:%02d" % [min, sec]
	if GameManager.is_debug_enabled:
		$DebugPanelMonsters/NumberMonsters.text = "Monsters:\n%03d" % GameManager.current_spawned_monster
	
