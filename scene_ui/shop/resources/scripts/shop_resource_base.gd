extends Resource
class_name ShopResourceBase

@export_category("Presentation")
@export var icon: Texture
@export var title: String
@export var id: String
@export var description: String
@export var cost: int
var is_purchased: bool = false

func apply(character: CharacterBase) -> void:
	pass
