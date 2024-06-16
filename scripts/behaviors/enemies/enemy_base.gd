class_name EnemyBase
extends CharacterBody2D

@onready var animated_sprite = $Sprite2D
@onready var animation_player = $AnimationPlayer
@onready var health: HealthComponent = $HealthComponent
@onready var launch_point: Marker2D = $LaunchStartPoint
@onready var drop_items_component: DropItemsComponent = $DropItemsComponent
@onready var debug_state: Label = $DEBUG_STATE
var ranged_attack_component: RangedAttackComponent
var melee_attack_component: MeleeAttackComponent

@export_category("Statistics")
@export var speed: int = 3
@export var damage_time_cooldown: int = 1
@export var deal_damage_time_cooldown: float = 0.5
@export_subgroup("Meele Attack")
@export var hit_damage: int = 1

@export_category("Death Params")
@export var death_prefab: PackedScene

# Calculated params:
var _hit_damage: int
var _damage_time_cooldown: float
var _deal_damage_time_cooldown: float
var _speed: float

var _deal_damage_cooldown: float = 0.0
var _dmg_cooldown: float = 0.0
var _is_damage_animation: bool = false
var run_from_player: bool = false

func _ready():
	if GameManager.is_debug_enabled:
		$DEBUG_STATE.visible = true
	else:
		$DEBUG_STATE.visible = false
	ranged_attack_component = get_node_or_null("RangedAttackComponent")
	melee_attack_component = get_node_or_null("MeleeAttackComponent")
	_hit_damage = hit_damage
	_damage_time_cooldown = damage_time_cooldown
	_deal_damage_time_cooldown = deal_damage_time_cooldown
	_speed = speed
	
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
	
func proccess_attack(target_position: Vector2, type: int) -> void:
	if not ranged_attack_component and not melee_attack_component:
		return
	
	if type != 1 and type != 2:
		return
	
	if melee_attack_component and type == 1:
		melee_attack_component.attack(target_position)
	elif ranged_attack_component and type == 2:
		ranged_attack_component.attack(target_position)

func is_range_to_attack_player() -> int:
	if not ranged_attack_component and not melee_attack_component:
		return 0
	
	if melee_attack_component:
		if melee_attack_component.is_range_attack_player():
			return 1
	
	if ranged_attack_component:
		if ranged_attack_component.is_range_attack_player():
			return 2
			
	return 0
	
func _on_health_equal_zero():
	die()


func _on_state_machine_transitioned(state_name):
	debug_state.text = state_name # Replace with function body.
