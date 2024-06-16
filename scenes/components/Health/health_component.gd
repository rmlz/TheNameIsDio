class_name HealthComponent
extends Node2D

var health_bar: ProgressBar

@export var max_health: int = 3
@export var show_bar = false
@export var damage_digit: PackedScene
var enemy_object: EnemyBase
var _health: int = 0

signal health_equal_zero
signal change_health

func _ready():
	_initialize_health()
	if (get_parent() is EnemyBase):
		enemy_object = get_parent()

func _process(delta):
	health_bar.visible = show_bar

# Starts health with Max health
func _initialize_health():
	if not health_bar:
		health_bar = $HealthBar
	_health = max_health
	change_health.emit()

# Damage this health with the absolute value param
# if you use negative values, it will be modified to positive
func damage(value: int) -> void:
	var absolute = absi(value)
	_health = max(_health - absolute, 0)
	show_damage_digit(absolute)
	change_health.emit()

# Heal this health with the absolute value param	
# if you use negative values, it will be modified to positive
func heal(value: int) -> void:
	_health = min(_health + absi(value), max_health)
	change_health.emit()
	
func healthScaling(scaler: float):
	max_health *= scaler
	_health *= scaler
	change_health.emit()

func _on_change_health():
	health_bar.max_value = max_health
	health_bar.value = _health
	health_bar.step = max_health / 100
	if _health <= 0:
		_health = 0
		health_equal_zero.emit()
	
func show_damage_digit(amount: int) -> void:
	if damage_digit:
		var digit: DamageDigit = damage_digit.instantiate( )
		digit.value = amount
		digit.position = enemy_object.get_node("DamageDigitMarker").global_position
		enemy_object.get_parent().add_child(digit)
