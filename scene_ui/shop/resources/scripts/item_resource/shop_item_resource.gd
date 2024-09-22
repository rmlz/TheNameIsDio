extends ShopResourceBase
class_name ShopItemResource

func apply(character: CharacterBase) -> void:
	match self.id:
		"arcane_amplifier": _add_arcane_aplifier(character)
		_: print("Apply item not implemented. ID: " + self.id)
			
func _add_arcane_aplifier(character: CharacterBase):
	character.inventory_component.add_item(self)
	character.melee_attack_component.attack_area.scale = Vector2(2, 1)
	if (GameManager.is_debug_enabled):
		print("Item applied: " + self.id)
