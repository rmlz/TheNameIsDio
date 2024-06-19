extends Node2D

@onready var path_follow_2d = $Path2D/PathFollow2D
@export_category("lvl1")
@export var lvl1_creatures: Array[PackedScene] = []
@export_category("lvl2")
@export var lvl2_creatures: Array[PackedScene] = []
@export_category("spawn_rate")
@export var initial_spawn_rate: int = 5
@export var spawn_rate_per_minute: float = 0.0
@export var wave_duration: int = 60
@export var break_intensity: float = 0.1

var mobs_per_minute: int = 0
var time: float = 0.0
var cooldown: float = 1

func _process(delta: float) -> void:
	cooldown -= delta
	time += delta
	if cooldown > 0: return
	var sin_wave = sin((time * TAU) / wave_duration)
	var wave_factor = remap(sin_wave, -1, 1, break_intensity, 1)
	var spawn_rate = initial_spawn_rate + spawn_rate_per_minute * (time/60) * wave_factor
	print(str(spawn_rate) + " " + str(time))
	mobs_per_minute = spawn_rate
	
	var interval: float = 60 / mobs_per_minute
	cooldown = interval
	
	var monsterSpawned: bool = false
	while not monsterSpawned:
		monsterSpawned = spawn_monster()
	
func spawn_monster() -> bool:
	if not GameManager.is_game_on_play() or not GameManager.can_spawn_monster():
		return true
	var creature_index: int
	var creature_scene: PackedScene
	if GameManager.points <= 100000:	
		creature_index = randi_range(0, lvl1_creatures.size() - 1)
		creature_scene = lvl1_creatures[creature_index]
	else:
		creature_index = randi_range(0, lvl2_creatures.size() - 1)
		creature_scene = lvl2_creatures[creature_index]
	var point = get_spawn_point()
	var state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = point
	if state.intersect_point(parameters, 1).size() > 0:
		return false
	
	var creature: Node2D = creature_scene.instantiate()
	creature.global_position = point
	
	get_parent().add_child(creature)
	GameManager.current_spawned_monster += 1
	return true

func get_spawn_point() -> Vector2:
	path_follow_2d.progress_ratio = randf()
	return path_follow_2d.global_position
	
