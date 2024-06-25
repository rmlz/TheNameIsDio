class_name EnemyBase
extends CharacterBase

@onready var drop_items_component: DropItemsComponent = $DropItemsComponent

@export_category("Statistics")
@export var deal_damage_time_cooldown: float = 0.5

# var _deal_damage_cooldown: float = 0.0
# var _dmg_cooldown: float = 0.0
# var _is_damage_animation: bool = false

func _ready():
	basic_setup()
	_deal_damage_time_cooldown = deal_damage_time_cooldown

func die() -> void:
	if death_prefab:
		var death_object = death_prefab.instantiate()
		death_object.position = position
		get_parent().add_child(death_object)
	drop_items_component.drop_items()
	GameManager.current_spawned_monster -= 1
	queue_free()

func is_range_to_attack_player() -> int:
	if not ranged_attack_component and not melee_attack_component:
		return 0
	
	if melee_attack_component:
		if melee_attack_component.is_range_attack():
			return 1
	
	if ranged_attack_component:
		if ranged_attack_component.is_range_attack():
			return 2
			
	return 0
	
func _on_health_equal_zero():
	die()
