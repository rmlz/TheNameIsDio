extends Node

var player_position: Vector2
var points: float = 0
var is_game_over: bool = false
var is_playing: bool = false
var is_touch_joypad_enabled = false

func reset():
	player_position = Vector2.ZERO
	points = 0
	is_game_over = false
	is_playing = false
	
func is_game_on_play() -> bool:
	return is_game_over or is_playing
