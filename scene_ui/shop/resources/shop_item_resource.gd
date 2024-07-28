@tool
extends Resource
class_name ShopItemResource

@export_category("Presentation")
@export var icon: Texture
@export var title: String
@export var description: String
@export var cost: int
var is_purchased: bool = false

@export_category("Settings")
@export var is_ritual: bool = true:
	set(value):
		is_ritual = value
		notify_property_list_changed()
		
@export var is_buff: bool:
	set(value):
		is_buff = value
		notify_property_list_changed()

@export_category("Ritual")
@export var cooldown: float
@export var scene: PackedScene

@export_category("Buff")
@export var buff_status_resource: PackedScene

func _validate_property(property: Dictionary):
	if property.name in ["cooldown", "scene"] and not is_ritual:
		cooldown = 0
		scene = null
		property.usage = PROPERTY_USAGE_NONE
	if property.name in ["buff_status_resource"] and not is_buff:
		buff_status_resource = null
		property.usage = PROPERTY_USAGE_NONE
