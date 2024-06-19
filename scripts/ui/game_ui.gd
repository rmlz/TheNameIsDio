extends Node

var end_time = 20

func _ready():
	$PanelPoints/Points.text = "Points: %09d" % [GameManager.points]
	$PanelTime/Time.text = "Time: %02d:%02d" % [end_time, 0]
	$DebugPanelMonsters.visible = GameManager.is_debug_enabled
	
func _process(delta):
	$PanelPoints/Points.text = "Points: %09d" % [GameManager.points]
	var time_left = (end_time * 60) - GameManager.time_elapsed
	if time_left <= 0:
		GameManager.is_game_over = true
		return
	var sec = fmod(time_left, 60.0)
	var min = int(time_left / 60)
	$PanelTime/Time.text = "Time: %02d:%02d" % [min, sec]
	if GameManager.is_debug_enabled:
		$DebugPanelMonsters/NumberMonsters.text = "Monsters:\n%03d" % GameManager.current_spawned_monster
	
