extends ShopItemResource
class_name ShopItemAtkScaleResource

@export_category("Mods")
@export var attack_area_scale: Vector2

func apply(character: CharacterBase) -> void:
	character.melee_attack_component.attack_area.scale = attack_area_scale
	character.inventory_component.add_item(self, character)
