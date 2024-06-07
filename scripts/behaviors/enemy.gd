class_name Enemy
extends CharacterBody2D

@onready var attack_area = $AttackArea

@export_category("Parameters")
@export var hit_damage: int = 1
@export var health: int = 3
@export var speed: int = 3
@export var damage_time_cooldown: int = 1
@export var deal_damage_time_cooldown: float = 0.5
@export var min_drops = 0
@export var max_drops = 3
@export var death_prefab: PackedScene
@export var drops: Array[PackedScene]
@export var damage_digit: PackedScene
@export var has_small: bool = false
@export var has_big: bool = false

@export_category("Small parameters")
@export var small_hit_damage_multiplier: float = 0.5
@export var small_health_multiplier: float = 0.5
@export var small_dmg_time_cd_multiplier: float = 0.5
@export var small_deal_dmg_time_cd_multipler: float = 0.5
@export var small_speed_multiplier: float = 2
@export var small_animation_multiplier: float = 1.2
@export var small_drops_modifier: int = -1
@export_category("Big parameters")
@export var big_hit_damage_multiplier: float = 2
@export var big_health_multiplier: float = 2
@export var big_dmg_time_cd_multiplier: float = 2
@export var big_deal_dmg_time_cd_multipler: float = 2
@export var big_speed_multiplier: float = 0.5
@export var big_animation_multiplier: float = 0.8
@export var big_drops_modifier: int = 1

# Calculated params:
var _health: int
var _hit_damage: int
var _damage_time_cooldown: float
var _deal_damage_time_cooldown: float
var _speed: float

var _deal_damage_cooldown: float = 0.0
var _dmg_cooldown: float = 0.0
var _is_damage_animation: bool = false

func _ready():
	modify_scale()
	
func damage(amount: int, collision_vector: Vector2, ignore_cooldown = false) -> void:
	_health -= amount
	_is_damage_animation = true
	if ignore_cooldown:
		_dmg_cooldown = 0
	else :
		_dmg_cooldown = _damage_time_cooldown
	velocity = collision_vector * 100
	damage_animation()
	show_damage_digit(amount)
	if _health <= 0:
		die()
	
func die() -> void:
	if death_prefab:
		var death_object = death_prefab.instantiate()
		death_object.position = position
		get_parent().add_child(death_object)
	drop_items()
	queue_free()
		
func damage_animation() -> void:
	var tween = create_tween()
	modulate = Color.DARK_RED
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property(
		self, "modulate", Color.WHITE, 0.3
	)

func show_damage_digit(amount: int) -> void:
	if damage_digit:
		var digit: DamageDigit = damage_digit.instantiate( )
		digit.value = amount
		digit.global_position = $DamageDigitMarker.global_position
		get_parent().add_child(digit)

func drop_items() -> void:
	if (drops.size() > 0):
		var number_of_drops = randi_range(min_drops, max_drops) 
		for i in range(number_of_drops):
			var drop_index = randi_range(0, drops.size() - 1)
			var drop = drops[drop_index].instantiate()
			drop.position = position + Vector2(randi_range(-100, 100), randi_range(-100, 100))
			get_parent().add_child(drop)
			
# Updates Damage animation time and returns true if damage is running
func update_damage_animation(delta: float) -> bool:
	if _is_damage_animation and _dmg_cooldown > 0:
		_dmg_cooldown -= delta
		return true
	return false
	
func end_damage_animation() -> void:
	if _is_damage_animation:
		_is_damage_animation = false
		_dmg_cooldown = damage_time_cooldown
		
func deal_damage(delta: float) -> void:
	if _deal_damage_cooldown > 0:
		velocity = Vector2.ZERO
		_deal_damage_cooldown -= delta
		return
	if _is_damage_animation:
		return
	var bodies = attack_area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("player"):
			var player: PlayerObject = body
			var direction_to_player = (player.position - position).normalized()
			player.getHit(hit_damage, direction_to_player)
			_deal_damage_cooldown = _deal_damage_time_cooldown
	
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
		_health = health * small_health_multiplier
		_hit_damage = hit_damage * small_hit_damage_multiplier
		_damage_time_cooldown = damage_time_cooldown * small_dmg_time_cd_multiplier
		_deal_damage_time_cooldown = deal_damage_time_cooldown * small_deal_dmg_time_cd_multipler
		_speed = speed * small_speed_multiplier
		min_drops += small_drops_modifier
		max_drops += small_drops_modifier
		$AnimatedSprite2D.set_speed_scale(small_animation_multiplier)
	if multiplier >= 2.1666 and has_big:
		#big sized
		_health = health * big_health_multiplier
		_hit_damage = hit_damage * big_hit_damage_multiplier
		_damage_time_cooldown = damage_time_cooldown * big_dmg_time_cd_multiplier
		_deal_damage_time_cooldown = deal_damage_time_cooldown * big_deal_dmg_time_cd_multipler
		_speed = speed * big_speed_multiplier
		min_drops += big_drops_modifier
		max_drops += big_drops_modifier
		$AnimatedSprite2D.set_speed_scale(big_animation_multiplier)
	else:
		#regular sized
		_health = health
		_hit_damage = hit_damage
		_damage_time_cooldown = damage_time_cooldown
		_deal_damage_time_cooldown = deal_damage_time_cooldown
		_speed = speed
