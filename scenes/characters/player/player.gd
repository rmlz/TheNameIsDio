class_name PlayerObject
extends CharacterBase

@onready var skill_progress_bars: PlayerSkillProgressBars = %SkillProgressBars
@onready var collect_audio: AudioStreamPlayer2D = $CollectAudio
@onready var attack_amplifier_player: AnimationPlayer = $AttackAmplifierPlayer
@onready var slash: Node2D = %SlashAmplifier
@onready var inventory_component: InventoryComponent = $InventoryComponent
@onready var state_machine: StateMachine = $StateMachine

@export var dash_ghost_scene: PackedScene

var _hit_cooldown: float = 0.0
var attack_cooldown: float = 0.65
const attack_cooldown_fix = 0.65
var input_vector: Vector2 = Vector2.ZERO
var is_attack_mobile_pressed: bool = false
var mobile_joypad: MobileJoypad

func _ready():
	status_component = $StatusComponent
	GameManager.on_new_item_bought.connect(update_by_item_bought)
	basic_setup()
	_hit_cooldown = statistics.get_hit_cooldown_secs
	
func update_by_item_bought(item: ShopResourceBase):
	item.apply(self)
		
func get_items() -> Dictionary:
	return inventory_component.items
	
func _process(delta: float) -> void:
	if GameManager.is_game_over:
		queue_free()
	
	GameManager.player_position = position
	GameManager.change_points_by(delta * 10)

	# Ataque
	if (Input.is_action_just_pressed("attack") and 
	not GameManager.is_touch_joypad_enabled) or is_attack_mobile_pressed:
		pass

func die() -> void:
	GameManager.is_game_over = true
	if death_prefab:
		var death_object = death_prefab.instantiate()
		death_object.position = position
		get_parent().add_child(death_object)
	
	queue_free()
	
func receive_damage(amount: int, collision_vector: Vector2, ignore_cooldown = false, play_audio = false) -> void:
	if amount == 0:
		return
	var is_tank = invicible
	if hit_audio and not is_tank:
		hit_audio.play(0)
	if tank_hit_audio and is_tank:
		tank_hit_audio.play(0)
	if health:
		health.damage(amount)
	run_damage_color_feedback(is_tank)
	if is_tank:
		return
	velocity = collision_vector * amount * 20

	state_machine.transition_to("StateCoolDown", {
		"cd_time": statistics.get_hit_cooldown_secs, 
		"hit": true, 
		"ignore_cd": ignore_cooldown
		})
		
func instance_dash_ghost() -> void:
	var ghost: Sprite2D = dash_ghost_scene.instantiate()
	ghost.global_position = global_position
	ghost.texture = %Sprite2D.texture
	ghost.vframes = %Sprite2D.vframes
	ghost.hframes = %Sprite2D.hframes
	ghost.frame = %Sprite2D.frame
	ghost.flip_h = %Sprite2D.flip_h
	
	add_sibling(ghost)

func emit_dash_burst() -> void:
	$DashParticles/DashBurstParticles.rotation = (velocity.normalized() * -1).angle()
	$DashParticles/DashBurstParticles.restart()
	

func _on_health_equal_zero():
	die()


func _on_skill_progress_bars_on_ritual_timer_timeout(ritual_scene: PackedScene):
	add_child(ritual_scene.instantiate())
