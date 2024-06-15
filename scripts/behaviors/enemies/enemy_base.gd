class_name EnemyBase
extends CharacterBody2D

@onready var attack_area = $AttackArea
@onready var animated_sprite = $Sprite2D
@onready var animation_player = $AnimationPlayer
@onready var health: HealthComponent = $HealthComponent
@onready var launch_point: Marker2D = $LaunchStartPoint
@onready var drop_items_component: DropItemsComponent = $DropItemsComponent

@export_category("Statistics")
@export var speed: int = 3
@export var damage_time_cooldown: int = 1
@export var deal_damage_time_cooldown: float = 0.5
@export var has_melee_atk: bool = true
@export var has_ranged_atk: bool = false
@export_subgroup("Meele Attack")
@export var hit_damage: int = 1

@export_category("Death Params")
@export var death_prefab: PackedScene

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
@export_subgroup("Big parameters")
@export var big_hit_damage_multiplier: float = 2
@export var big_health_multiplier: float = 2
@export var big_dmg_time_cd_multiplier: float = 2
@export var big_deal_dmg_time_cd_multipler: float = 2
@export var big_speed_multiplier: float = 0.5
@export var big_animation_multiplier: float = 0.8
@export var big_drops_modifier: int = 1

# Calculated params:
var _hit_damage: int
var _damage_time_cooldown: float
var _deal_damage_time_cooldown: float
var _speed: float

var _deal_damage_cooldown: float = 0.0
var _dmg_cooldown: float = 0.0
var _is_damage_animation: bool = false
var run_from_player: bool = false

var ranged_attack_component: RangedAttackComponent
var melee_attack_component: MeleeAttackComponent

func _ready():
	ranged_attack_component = get_node_or_null("RangedAttackComponent")
	melee_attack_component = get_node_or_null("MeleeAttackComponent")
	modify_scale()
	
func receive_damage(amount: int, collision_vector: Vector2, ignore_cooldown = false) -> void:
	if health:
		health.damage(amount)
	run_damage_color_feedback()
	velocity = collision_vector * 100
	if $StateMachine.current_state == "StateCoolDown":
		$StateMachine/StateCoolDown.add_time(damage_time_cooldown)
	else:
		$StateMachine.transition_to("StateCoolDown", {"cd_time": damage_time_cooldown})
	
func run_damage_color_feedback() -> void:
	var tween = create_tween()
	modulate = Color.DARK_RED
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property(
		self, "modulate", Color.WHITE, 0.3
	)

func die() -> void:
	if death_prefab:
		var death_object = death_prefab.instantiate()
		death_object.position = position
		get_parent().add_child(death_object)
	drop_items_component.drop_items()
	queue_free()


	
func modify_scale() -> void:
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
	var scale_vector = Vector2(multiplier, multiplier)
	apply_scale(scale_vector)
	if multiplier <= 1.3333 and has_small:
		#small sized
		health.healthScaling(small_health_multiplier)
		_hit_damage = hit_damage * small_hit_damage_multiplier
		_damage_time_cooldown = damage_time_cooldown * small_dmg_time_cd_multiplier
		_deal_damage_time_cooldown = deal_damage_time_cooldown * small_deal_dmg_time_cd_multipler
		_speed = speed * small_speed_multiplier
		drop_items_component.min_drops += small_drops_modifier
		drop_items_component.max_drops += small_drops_modifier
		$AnimationPlayer.set_speed_scale(small_animation_multiplier)
	if multiplier >= 2.1666 and has_big:
		#big sized
		health.healthScaling(big_health_multiplier)
		_hit_damage = hit_damage * big_hit_damage_multiplier
		_damage_time_cooldown = damage_time_cooldown * big_dmg_time_cd_multiplier
		_deal_damage_time_cooldown = deal_damage_time_cooldown * big_deal_dmg_time_cd_multipler
		_speed = speed * big_speed_multiplier
		drop_items_component.min_drops += big_drops_modifier
		drop_items_component.max_drops += big_drops_modifier
		$AnimationPlayer.set_speed_scale(big_animation_multiplier)
	else:
		#regular sized
		_hit_damage = hit_damage
		_damage_time_cooldown = damage_time_cooldown
		_deal_damage_time_cooldown = deal_damage_time_cooldown
		_speed = speed
	
func proccess_attack(target_position: Vector2) -> void:
	if not ranged_attack_component and not melee_attack_component:
		return
	
	if melee_attack_component:
		if melee_attack_component.attack(target_position):
			return
	
	if ranged_attack_component:
		ranged_attack_component.attack(target_position)
	
	
	
func _on_health_equal_zero():
	die()
