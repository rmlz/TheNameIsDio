class_name Status
extends Node

signal status_applied(status: Status, target: CharacterBase)
signal status_changed

enum StackType {NONE, INTENSITY, DURATION}

@export_group("Status Data")
@export var id: String
@export var stack_type: StackType
@export var can_expire: bool
@export var duration: int: set = set_duration
@export var stacks: int: set = set_stacks
var add_stacks = stacks

@export_category("Status Parameters")
@export_range(0, 100) var damage_per_application: int = 1
@export_range(-1, 1) var speed_mod_percent: float = 0
@export_range(-1, 1) var attack_mod_percent: float = 0 
@export var seconds: float = 1

@export_group("Status Visuals")
@export var icon: Texture

var character_owner: CharacterBase
var apply_timer: Timer
	
func _physics_process(_delta):
	_proccess_status_on_physics()

func initialize_status(_target: CharacterBase) -> void:
	character_owner = _target
	apply_timer = get_node_or_null("ApplyTimer")
	if apply_timer:
		apply_timer.start(seconds)
		apply_timer.timeout.connect(on_apply_timer_timeout)
	
func apply_status() -> void:
	status_applied.emit(self)
	animate()
	_proccess_status_on_timer()
	
func set_duration(new_duration: int) -> void:
	duration = new_duration
	status_changed.emit()
	
func set_stacks(new_stacks: int) -> void:
	stacks = new_stacks
	status_changed.emit()
	
func expire() -> void:
	character_owner._speed = character_owner._calc_speed
	
func animate() -> void:
	pass

func _proccess_status_on_timer():
	if not character_owner:
		return
	if stack_type == StackType.DURATION:
		character_owner.receive_damage(damage_per_application, Vector2.ZERO, true)
	if stack_type == StackType.INTENSITY:
		character_owner.receive_damage(damage_per_application * stacks, Vector2.ZERO, true)
		
func _proccess_status_on_physics():
	if not character_owner:
		return
	if stack_type == StackType.DURATION:
		character_owner._speed = character_owner._calc_speed
		character_owner._speed *= (1 + speed_mod_percent)
		character_owner._hit_damage = character_owner._calc_hit_damage
		character_owner._hit_damage *= (1 + attack_mod_percent)
	if stack_type == StackType.INTENSITY:
		character_owner._speed = character_owner._calc_speed
		character_owner._speed *= (1 + speed_mod_percent) ** stacks
		character_owner._hit_damage = character_owner._calc_hit_damage
		character_owner._hit_damage *= (1 + attack_mod_percent) ** stacks
		
func on_apply_timer_timeout() -> void:
	apply_status()
	apply_timer.start(seconds)

