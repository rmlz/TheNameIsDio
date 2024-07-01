extends Node2D

var path_follow_array: Array[PathFollow2D] = []
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

var mobs_per_minute: float = 0
var time: float = 0.0
var cooldown: float = 1

func _ready():
	for path2d: Path2D in get_children():
		path_follow_array.append(path2d.get_child(0))

func _process(delta: float) -> void:
	cooldown -= delta
	time += delta
	if cooldown > 0: return
	var sin_wave = sin((time * TAU) / wave_duration)
	var wave_factor = remap(sin_wave, -1, 1, break_intensity, 1)
	var spawn_rate = (initial_spawn_rate + spawn_rate_per_minute) * wave_factor
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
	print("cooldown = %03f" % cooldown) 
	
	var monsterSpawned: bool = false
	while not monsterSpawned:
		monsterSpawned = spawn_monsters()
	
func spawn_monsters() -> bool:
	if not GameManager.is_game_on_play() or not GameManager.can_spawn_monster():
		return true
	var creature_odd: int
	var creature_scenes: Array[PackedScene]
	
	if time < 1020:
		creature_scenes.append(get_next_creature(lvl1_creatures))
		if time > 300:
			creature_scenes.append(get_next_creature(lvl2_creatures))
		if time > 600:
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
			print("Spawned: %1s" % creature.name)
			creature.global_position = points[idx]
			get_parent().add_child(creature)
			GameManager.current_spawned_monster += 1
			has_spawned_monster = true
	
	return has_spawned_monster
	
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
	
