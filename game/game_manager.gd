extends Node

signal on_change_points
signal on_change_time_left
signal on_change_spawn_number
signal on_new_item_bought

var player_position: Vector2
var _points: float = 0 : set = _set_points
	
var is_game_over: bool = false
var is_playing: bool = false
var is_touch_joypad_enabled = false
var is_debug_enabled = false
var _time_elapsed: float = 0.0
var max_game_time: int = 20 #minutes
var _time_left: float = 0.0

var _max_spawned_monsters = 500
var _current_spawned_monster = 0
var version = ProjectSettings.get_setting("application/config/version")

func _process(delta):
	if is_game_on_play():
		_update_timer(delta)

func reset():
	player_position = Vector2.ZERO
	_points = 0
	is_game_over = false
	is_playing = false
	_time_elapsed = 0.0
	_current_spawned_monster = 0
	
func is_game_on_play() -> bool:
	return is_game_over or is_playing
	
func can_spawn_monster() -> bool:
	return _current_spawned_monster < _max_spawned_monsters

func change_monster_spawn_number_by(value: int):
	_current_spawned_monster += value
	on_change_spawn_number.emit(_current_spawned_monster)

func _update_timer(delta: float) -> void:
	_time_elapsed = min(max_game_time * 60, _time_elapsed + delta)
	_time_left = max(0, (max_game_time * 60) - _time_elapsed)
	on_change_time_left.emit(_time_left)
	if _time_left <= 0:
		is_game_over = true
		return

func get_time_left() -> int:
	return _time_left
	
func change_points_by(value: float):
	_set_points(_points + value)
	
func _set_points(value: float):
	_points = value
	on_change_points.emit(_points)
	
func get_points() -> int:
	return _points
	
func on_buy_shop_item(item: ShopResourceBase):
	on_new_item_bought.emit(item)
