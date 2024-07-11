extends Node

signal turn_ritual_2_on
signal turn_ritual_3_on

var player_position: Vector2
var points: float = 0
var is_game_over: bool = false
var is_playing: bool = false
var is_touch_joypad_enabled = false
var is_debug_enabled = true
var time_elapsed: float = 0.0
var max_game_time: int = 20 #minutes
var time_left: float = 0.0

var max_spawned_monsters = 500
var current_spawned_monster = 0
var version = ProjectSettings.get_setting("application/config/version")

var ritual2_started = false
var ritual3_started = false

func _process(delta):
	if is_game_on_play():
		time_elapsed = min(max_game_time * 60, time_elapsed + delta)
		time_left = max(0, (max_game_time * 60) - time_elapsed)
		if time_left <= 0:
			is_game_over = true
			return
		if time_elapsed >= 300 and not ritual2_started:
			ritual2_started = true
			turn_ritual_2_on.emit()
		if time_elapsed >= 600 and not ritual3_started:
			ritual3_started = true
			turn_ritual_3_on.emit()

func reset():
	player_position = Vector2.ZERO
	points = 0
	is_game_over = false
	is_playing = false
	time_elapsed = 0.0
	current_spawned_monster = 0
	ritual2_started = false
	ritual3_started = false
	
func is_game_on_play() -> bool:
	return is_game_over or is_playing
	
func can_spawn_monster() -> bool:
	return current_spawned_monster < max_spawned_monsters
