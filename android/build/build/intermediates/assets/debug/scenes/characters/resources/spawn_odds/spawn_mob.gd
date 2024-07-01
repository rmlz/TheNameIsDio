class_name SpawnMob
extends Resource

# mob scene. Must be of class Enemy
@export var mob_scene: PackedScene

# the higher the value, the higher the odds to be spawned
@export_range(1, 10) var mob_odds: int = 1


