class_name CharacterBase
extends CharacterBody2D

@onready var animated_sprite = $Sizeable/Sprite2D
@onready var launch_point: Marker2D = $Sizeable/LaunchStartPoint
@onready var health: HealthComponent = $HealthComponent
@onready var animation_player = $AnimationPlayer
@onready var debug_state: Label = $DEBUG_STATE
var ranged_attack_component: BaseRangedAttackComponent
var melee_attack_component: BaseMeleeAttackComponent
var status_component: StatusComponent
var size_changer: SizeChanger
@export var statistics: CharacterStatistics

var death_prefab: PackedScene

# Calculated constant params
var _calc_hit_damage: int
var _calc_damage_time_cooldown: float
var _calc_deal_damage_time_cooldown: float
var _calc_speed: float

# Variant params:
var _hit_damage: int
var _damage_time_cooldown: float
var _deal_damage_time_cooldown: float
var _speed: float

func _ready():
	basic_setup()
	
func basic_setup() -> void:
	if GameManager.is_debug_enabled:
		$DEBUG_STATE.visible = true
	else:
		$DEBUG_STATE.visible = false
	ranged_attack_component = get_node_or_null("RangedAttackComponent")
	melee_attack_component = get_node_or_null("Sizeable/MeleeAttackComponent")
	status_component = get_node_or_null("StatusComponent")
	size_changer = get_node_or_null("SizeChanger")
	death_prefab = statistics.death_prefab
	calculate_params()
	
	
func calculate_params():
	_calc_hit_damage = statistics.hit_damage
	_calc_damage_time_cooldown = statistics.get_hit_cooldown_secs
	_calc_speed = statistics.speed
	
	_hit_damage = _calc_hit_damage
	_damage_time_cooldown = _calc_damage_time_cooldown
	_speed = _calc_speed
	
	health.initialize_health(statistics.max_health)
	if size_changer:
		change_size(size_changer.get_scale_vector(statistics.size))
	
func change_size(vector: Vector2):
	for node: Node2D in $Sizeable.get_children():
		node.apply_scale(vector)
	$CollisionShape2D.apply_scale(vector)


func receive_damage(amount: int, collision_vector: Vector2, ignore_cooldown = false) -> void:
	if amount == 0:
		return
	var is_tank = statistics.get_hit_cooldown_secs == 0
	if health:
		health.damage(amount)
	run_damage_color_feedback(is_tank)
	if is_tank:
		return
	velocity = collision_vector * amount * 200

	$StateMachine.transition_to("StateCoolDown", {
		"cd_time": statistics.get_hit_cooldown_secs, 
		"hit": true, 
		"ignore_cd": ignore_cooldown
		})
	
func run_damage_color_feedback(is_tank: bool) -> void:
	var tween = create_tween()
	if is_tank:
		modulate = Color.AQUAMARINE
		modulate.v = 5
	else :
		modulate = Color.DARK_RED
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property(
		self, "modulate", Color.WHITE, 0.3
	)

func proccess_attack(target_position: Vector2, type: int) -> void:
	if not ranged_attack_component and not melee_attack_component:
		return
	
	if type != 1 and type != 2:
		return
	
	if melee_attack_component and type == 1:
		melee_attack_component.attack(target_position)
	elif ranged_attack_component and type == 2:
		ranged_attack_component.attack(target_position)
		
func _on_state_machine_transitioned(state_name):
	debug_state.text = state_name
	
