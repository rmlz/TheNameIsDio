extends Node

var player_position: Vector2
var points: float = 0
var is_game_over: bool = false
var is_playing: bool = false
var is_touch_joypad_enabled = false
var is_debug_enabled = false
var time_elapsed: float = 0.0

func _process(delta):
	time_elapsed += delta

func reset():
	player_position = Vector2.ZERO
	points = 0
	is_game_over = false
	is_playing = false
	time_elapsed = 0.0
	
func is_game_on_play() -> bool:
	return is_game_over or is_playing
