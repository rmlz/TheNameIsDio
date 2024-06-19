class_name PlayerObject
extends CharacterBase

@onready var ritual_1_bar: ProgressBar = $Ritual1Bar
var ritual_1_timer: Timer

@export var ritual1: PackedScene
@export var ritual1_cooldown: int = 15

var _hit_cooldown: float = get_hit_cooldown_secs
var attack_cooldown: float = 0.65
const attack_cooldown_fix = 0.65
var input_vector: Vector2 = Vector2.ZERO
var is_attack_mobile_pressed: bool = false
var mobile_joypad: CanvasLayer

func _ready(): 
	basic_setup()
	ritual_1_timer = $Ritual1Timer
	ritual_1_timer.wait_time = ritual1_cooldown
	ritual_1_timer.start()
	
func _process(delta: float) -> void:
	ritual_1_bar.value = ritual_1_timer.time_left / ritual1_cooldown * 100
	GameManager.player_position = position
	GameManager.points += delta * 10

	# Ataque
	if (Input.is_action_just_pressed("attack") and 
	not GameManager.is_touch_joypad_enabled) or is_attack_mobile_pressed:
		pass
		#attack()

func damage_animation() -> void:
	var tween = create_tween()
	%Sprite2D.modulate = Color.DARK_RED
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property(
		%Sprite2D, "modulate", Color.WHITE, 0.3
	)

func die() -> void:
	GameManager.is_game_over = true
	if death_prefab:
		var death_object = death_prefab.instantiate()
		death_object.position = position
		get_parent().add_child(death_object)
	
	queue_free()

func _on_ritual_1_timer_timeout():
	startRitualOne()
	
func startRitualOne() -> void:
	var ritual = ritual1.instantiate()
	add_child(ritual)

func _on_health_equal_zero():
	die()
