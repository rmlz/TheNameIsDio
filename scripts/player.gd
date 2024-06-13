class_name PlayerObject
extends CharacterBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D
@onready var sword_area: Area2D = $SwordArea
@onready var health_bar: ProgressBar = $HealthBar
@onready var ritual_1_bar: ProgressBar = $Ritual1Bar
var ritual_1_timer: Timer

@export var health: int = 100
@export var max_health: int = 200
@export var death_prefab: PackedScene
@export var ritual1: PackedScene
@export var ritual1_cooldown: int = 15
@export var speed: int = 3
@export var sword_damage: int = 1
@export var get_hit_cooldown_secs: float = 0.5

var _hit_cooldown: float = get_hit_cooldown_secs
var attack_cooldown: float = 0.65
const attack_cooldown_fix = 0.65
var input_vector: Vector2 = Vector2.ZERO
var is_attack_mobile_pressed: bool = false

var is_running: bool = false
var is_attacking: bool = false
var is_hitten: bool = false

func _ready(): 
	ritual_1_timer = $Ritual1Timer
	ritual_1_timer.wait_time = ritual1_cooldown
	ritual_1_timer.start()
	health_bar.max_value = max_health

func _physics_process(delta) -> void:
	move_character()
	
func _process(delta: float) -> void:
	health_bar.value = health
	ritual_1_bar.value = ritual_1_timer.time_left / ritual1_cooldown * 100
	GameManager.player_position = position
	GameManager.points += delta * 10
	update_attack_cooldown(delta)
	update_animation() 
	# Ataque
	if (Input.is_action_just_pressed("attack") and 
	not GameManager.is_touch_joypad_enabled) or is_attack_mobile_pressed:
		attack()
		
	
	if is_hitten:
		if _hit_cooldown <= 0:
			_hit_cooldown = get_hit_cooldown_secs
			is_hitten = false
		_hit_cooldown -= delta

func update_attack_cooldown(delta: float) -> void:
	if is_attacking:
		attack_cooldown -= delta
	if attack_cooldown <= 0:
		is_attacking = false
		attack_cooldown = attack_cooldown_fix
		
func move_character() -> void:
	# Obter o input vector
	if not GameManager.is_touch_joypad_enabled:
		input_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down", 0.15)
	
	# Modificar a velocidade
	var target_velocity = input_vector * speed * 100
	if is_attacking:
		target_velocity = velocity * 0.7
	velocity = lerp(velocity, target_velocity, 0.25)
	move_and_slide()
	
func update_animation() -> void:
	# Tocar a animação
	is_running = not input_vector.is_zero_approx()
	
	if is_running and not is_attacking:
		animation_player.play("run")
	elif not is_attacking:
		animation_player.play("idle")
		
	# Girar sprite
	if input_vector.x > 0 and not is_attacking:
		sprite.flip_h = false
	if input_vector.x < 0 and not is_attacking:
		sprite.flip_h = true

func attack() -> void:
	is_attack_mobile_pressed = false
	if is_attacking:
		return
		
	animation_player.play("attack-side")
	is_attacking = true

func deal_damage() -> void:
	var bodies = sword_area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemies"):
			var enemy: EnemyBase = body
			var direction_to_enemy = (enemy.position - position).normalized()
			var attack_direction: Vector2
			if sprite.flip_h:
				attack_direction = Vector2.LEFT
			else:
				attack_direction = Vector2.RIGHT
			var dot_product = direction_to_enemy.dot(attack_direction)
			if dot_product >= 0.1:
				enemy.damage(sword_damage, direction_to_enemy)

func damage_animation() -> void:
	var tween = create_tween()
	%Sprite2D.modulate = Color.DARK_RED
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property(
		%Sprite2D, "modulate", Color.WHITE, 0.3
	)

func get_hit(dmg: int, collision_vector: Vector2) -> void:
	if not is_hitten:
		damage_animation()
		velocity = collision_vector * dmg * 15
		health -= dmg
		is_hitten = true
		if health <= 0:
			die()

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


func _on_mobile_joypad_use_move_vector(vector: Vector2):
	input_vector = vector


func _on_mobile_joypad_use_hit_button():
	is_attack_mobile_pressed = true # Replace with function body.
