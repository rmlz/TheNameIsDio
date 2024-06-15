class_name Sizeable
extends Node

@export_category("Size Params")
@export var has_small: bool = false
@export var has_big: bool = false
@export_subgroup("Small parameters")
@export var small_hit_damage_multiplier: float = 0.5
@export var small_health_multiplier: float = 0.5
@export var small_dmg_time_cd_multiplier: float = 0.5
@export var small_deal_dmg_time_cd_multipler: float = 0.5
@export var small_speed_multiplier: float = 2
@export var small_animation_multiplier: float = 1.2
@export var small_drops_modifier: int = -1
@export_range(0.1,10, 0.1) var small_melee_atk_range_multiplier: float = 1
@export_range(0.1,10, 0.1) var small_ranged_atk_range_multiplier: float = 1
@export_subgroup("Big parameters")
@export var big_hit_damage_multiplier: float = 2
@export var big_health_multiplier: float = 2
@export var big_dmg_time_cd_multiplier: float = 2
@export var big_deal_dmg_time_cd_multipler: float = 2
@export var big_speed_multiplier: float = 0.5
@export var big_animation_multiplier: float = 0.8
@export var big_drops_modifier: int = 1
@export_range(0.1,10, 0.1) var big_melee_atk_range_multiplier: float = 1
@export_range(0.1,10, 0.1) var big_ranged_atk_range_multiplier: float = 1

var enemy: EnemyBase

func _ready():
	await(owner._ready())
	enemy = owner as EnemyBase
	modify_scale()

func modify_scale() -> void:
	var scale_vector = get_scale_vector()
	enemy.apply_scale(scale_vector)
	if scale_vector.x <= 1.3333 and has_small:
		#small sized
		scale_small()
	if scale_vector.x >= 2.1666 and has_big:
		#big sized
		scale_big()
		
func get_scale_vector() -> Vector2:
	var min_range = 1.0
	var max_range = 1.0
	if has_small and has_big:
		min_range = 0.5
		max_range = 3
	elif has_small:
		min_range = 0.5
		max_range = 2.0
	elif has_big:
		min_range = 1.34
		max_range = 3
	var multiplier = randf_range(min_range, max_range)
	return Vector2(multiplier, multiplier)

func scale_small():
	enemy.health.healthScaling(small_health_multiplier)
	enemy._hit_damage = enemy.hit_damage * small_hit_damage_multiplier
	enemy._damage_time_cooldown = enemy.damage_time_cooldown * small_dmg_time_cd_multiplier
	enemy._deal_damage_time_cooldown = enemy.deal_damage_time_cooldown * small_deal_dmg_time_cd_multipler
	enemy._speed = enemy.speed * small_speed_multiplier
	enemy.drop_items_component.min_drops += small_drops_modifier
	enemy.drop_items_component.max_drops += small_drops_modifier
	enemy.animation_player.set_speed_scale(small_animation_multiplier)
	if enemy.melee_attack_component:
		enemy.melee_attack_component.attack_area.apply_scale(
			Vector2(
				small_melee_atk_range_multiplier, small_melee_atk_range_multiplier
				))
	if enemy.ranged_attack_component:
		enemy.ranged_attack_component.attack_area.apply_scale(
			Vector2(
				small_ranged_atk_range_multiplier, small_ranged_atk_range_multiplier
				))
	
func scale_big():
	enemy.health.healthScaling(big_health_multiplier)
	enemy._hit_damage = enemy.hit_damage * big_hit_damage_multiplier
	enemy._damage_time_cooldown = enemy.damage_time_cooldown * big_dmg_time_cd_multiplier
	enemy._deal_damage_time_cooldown = enemy.deal_damage_time_cooldown * big_deal_dmg_time_cd_multipler
	enemy._speed = enemy.speed * big_speed_multiplier
	enemy.drop_items_component.min_drops += big_drops_modifier
	enemy.drop_items_component.max_drops += big_drops_modifier
	enemy.animation_player.set_speed_scale(big_animation_multiplier)
	if enemy.melee_attack_component:
		enemy.melee_attack_component.attack_area.apply_scale(
			Vector2(
				big_melee_atk_range_multiplier, big_melee_atk_range_multiplier
				))
	if enemy.ranged_attack_component:
		enemy.ranged_attack_component.attack_area.apply_scale(
			Vector2(
				big_ranged_atk_range_multiplier, big_ranged_atk_range_multiplier
				))
