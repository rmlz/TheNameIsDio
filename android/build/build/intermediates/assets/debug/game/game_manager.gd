extends Node

signal turn_ritual_2_on

var player_position: Vector2
var points: float = 0
var is_game_over: bool = false
var is_playing: bool = false
var is_touch_joypad_enabled = false
var is_debug_enabled = false
var time_elapsed: float = 0.0

var max_spawned_monsters = 500
var current_spawned_monster = 0

var ritual2_started = false

func _process(delta):
	if is_game_on_play():
		time_elapsed += delta
		if time_elapsed >= 300 and not ritual2_started:
			ritual2_started = true
			turn_ritual_2_on.emit()

func reset():
	player_position = Vector2.ZERO
	points = 0
	is_game_over = false
	is_playing = false
	time_elapsed = 0.0
	current_spawned_monster = 0
	ritual2_started = false
	
func is_game_on_play() -> bool:
	return is_game_over or is_playing
	
func can_spawn_monster() -> bool:
	return current_spawned_monster < max_spawned_monsters
