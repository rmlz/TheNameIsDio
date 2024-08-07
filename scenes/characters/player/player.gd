class_name PlayerObject
extends CharacterBase

@onready var skill_progress_bars: PlayerSkillProgressBars = %SkillProgressBars
@onready var collect_audio: AudioStreamPlayer2D = $CollectAudio
@onready var attack_amplifier_player: AnimationPlayer = $AttackAmplifierPlayer
@onready var slash: Node2D = %SlashAmplifier

@export var ritual1: PackedScene
@export var ritual1_cooldown: int = 13

@export var ritual2: PackedScene
@export var ritual2_cooldown: int = 19

@export var ritual3: PackedScene
@export var ritual3_cooldown: int = 23

var _hit_cooldown: float = 0.0
var attack_cooldown: float = 0.65
const attack_cooldown_fix = 0.65
var input_vector: Vector2 = Vector2.ZERO
var is_attack_mobile_pressed: bool = false
var mobile_joypad: CanvasLayer

func _ready():
	status_component = $StatusComponent
	GameManager.on_new_item_bought.connect(update_by_item_bought)
	basic_setup()
	_hit_cooldown = statistics.get_hit_cooldown_secs
	
func update_by_item_bought(item: ShopItemResource):
	if item.is_ritual:
		skill_progress_bars.add_ritual(item)
	if item.is_buff:
		add_buff(item)
	if item.is_item:
		$InventoryComponent.add_item(item)
		
func get_items() -> Dictionary:
	return {
		"arcane_amplifier": $InventoryComponent.arcane_amplifier
	}

func add_buff(item: ShopItemResource):
	var status: Status = item.buff_status_resource.instantiate()
	status_component.add_status(status, self)
	GameManager.change_points_by(-item.cost)
	
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

func _on_health_equal_zero():
	die()


func _on_skill_progress_bars_on_ritual_timer_timeout(ritual_scene: PackedScene):
	add_child(ritual_scene.instantiate())
