class_name HealthComponent
extends Node2D

var health_bar: ProgressBar

var max_health: float
@export var show_bar = false
@export var damage_digit: PackedScene
var enemy_object: EnemyBase
var _health: float = 0

signal health_equal_zero
signal change_health

func _ready():
	if (get_parent() is EnemyBase):
		enemy_object = get_parent()
	health_bar = $HealthBar

func _process(_delta):
	health_bar.visible = show_bar

# Starts health with Max health
func initialize_health(new_max_health: float):
	if not health_bar:
		health_bar = $HealthBar
	max_health = new_max_health
	_health = max_health
	change_health.emit()

# Damage this health with the absolute value param
# if you use negative values, it will be modified to positive
func damage(value: int) -> void:
	var absolute = absi(value)
	_health = max(_health - absolute, 0)
	if enemy_object:
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
		digit.position = enemy_object.get_node("Sizeable/DamageDigitMarker").global_position
		enemy_object.get_parent().add_child(digit)
