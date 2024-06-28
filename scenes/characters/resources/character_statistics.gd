class_name CharacterStatistics
extends Resource

@export_category("Statistics")
@export var max_health: float = 3
@export var speed: float = 3
@export var get_hit_cooldown_secs: float = 0.5
@export var hit_damage: int = 1
@export var size: SizeChanger.Sizes

@export_category("Death Params")
@export var death_prefab: PackedScene
