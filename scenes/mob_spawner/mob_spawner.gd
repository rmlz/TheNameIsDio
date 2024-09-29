extends Node2D

var path_follow_array: Array[PathFollow2D] = []
@export_category("start")
@export var start_creature_numbers = 10
@export_category("lvl1")
@export var lvl1_creatures: Array[SpawnMob] = []
@export_category("lvl2")
@export var lvl2_creatures: Array[SpawnMob] = []
@export_category("lvl3")
@export var lvl3_creatures: Array[SpawnMob] = []
@export_category("lvl4")
@export var lvl4_creatures: Array[SpawnMob] = []
@export_category("spawn_rate")
@export var initial_spawn_rate: int = 5
@export var spawn_rate_per_minute: float = 0.0
@export var wave_duration: int = 30
@export var break_intensity: float = 0.1
var is_start = true

var mobs_per_minute: float = 0
var time: float = 0.0
var cooldown: float = 1

func _ready():
	for path2d: Path2D in get_children():
		path_follow_array.append(path2d.get_child(0))
	for i in range(start_creature_numbers):
		spawn_monsters()
	is_start = false
	

func _process(delta: float) -> void:
	cooldown -= delta
	time += delta
	if cooldown > 0: return
	var sin_wave = sin((time * TAU) / wave_duration)
	var wave_factor = remap(sin_wave, -1, 1, break_intensity, 1)
	var spawn_rate = (initial_spawn_rate + spawn_rate_per_minute) * wave_factor
	if GameManager.is_debug_enabled:
		print(
	"""
--------
Sin_wave = %05f
Wave_factor = %05f
spawn_rate = %05f
--------
	""" % [sin_wave, wave_factor, spawn_rate])
	mobs_per_minute = spawn_rate
	
	var interval: float = 60 / mobs_per_minute
	cooldown = interval
	if GameManager.is_debug_enabled:
		print("cooldown = %03f" % cooldown) 
	
	var monsterSpawned: bool = false
	while not monsterSpawned:
		monsterSpawned = spawn_monsters()
	
func spawn_monsters() -> bool:
	if not GameManager.is_game_on_play() or not GameManager.can_spawn_monster():
		return true
	var creature_odd: int
	var creature_scenes: Array[PackedScene]
	
	if is_start:
		return _spawn_start_monsters(get_next_creature(lvl1_creatures))
	if GameManager.get_time_elapsed_percent() <= 0.85:
		creature_scenes.append(get_next_creature(lvl1_creatures))
		if GameManager.get_time_elapsed_percent() > 0.25:
			creature_scenes.append(get_next_creature(lvl2_creatures))
		if GameManager.get_time_elapsed_percent() > 0.5:
			creature_scenes.append(get_next_creature(lvl3_creatures))
	else:
		creature_scenes.append(get_next_creature(lvl4_creatures))
	
	return _spawn_monsters(creature_scenes)

func _spawn_monsters(creature_scenes: Array[PackedScene]) -> bool:
	var has_spawned_monster: bool = false
	var points: Array[Vector2] = get_spawn_point()
	var state = get_world_2d().direct_space_state
	for idx: int in range(creature_scenes.size()):
		var parameters = PhysicsPointQueryParameters2D.new()
		if creature_scenes.size() > points.size():
			idx = randi_range(0, points.size())
		parameters.position = points[idx]
		if not state.intersect_point(parameters, 1).size() > 0:
			if not creature_scenes[idx]:
				continue
			var creature: Node2D = creature_scenes[idx].instantiate()
			if GameManager.is_debug_enabled:
				print("Spawned: %1s" % creature.name)
				print("Distance: %1f" % parameters.position.distance_to(GameManager.player_position))
			creature.global_position = points[idx]
			get_parent().add_child(creature)
			GameManager.change_monster_spawn_number_by(1)
			has_spawned_monster = true
	
	return has_spawned_monster

func _spawn_start_monsters(creature_scene: PackedScene) -> bool:
	var point: Vector2 = get_spawn_point()[3]
	var state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = point
	if not state.intersect_point(parameters, 1).size() > 0:
		var creature: Node2D = creature_scene.instantiate()
		if GameManager.is_debug_enabled:
			print("Spawned: %1s" % creature.name)
			print("Distance: %1f" % point.distance_to(GameManager.player_position))
		creature.global_position = point
		get_parent().add_child.call_deferred(creature)
		GameManager.change_monster_spawn_number_by(1)
		return true
	return false
	
func get_next_creature(array: Array[SpawnMob]) -> PackedScene:
	var max_odds = 0
	for mob: SpawnMob in array:
		max_odds += mob.mob_odds
	
	var creature_odd = randi_range(1, max_odds)
	for mob : SpawnMob in array:
		creature_odd -= mob.mob_odds
		if creature_odd <= 0:
			return mob.mob_scene
	return null

func get_spawn_point() -> Array[Vector2]:
	var result: Array[Vector2] = []
	for path: PathFollow2D in path_follow_array:
		path.progress_ratio = randf()
		result.append(path.global_position)
	
	return result
	
