extends ShopResourceBase
class_name ShopItemResource

func apply(character: CharacterBase) -> void:
	match self.id:
		"arcane_amplifier": _add_arcane_amplifier(character)
		"lunge_boost": _add_lunge_boost(character)
		_: print("Apply item method not implemented for ID: " + self.id)
	GameManager.change_points_by(-self.cost)
			
func _add_arcane_amplifier(character: CharacterBase):
	character.inventory_component.add_item(self)
	character.melee_attack_component.attack_area.scale = Vector2(2, 1)
	if (GameManager.is_debug_enabled):
		print("Item applied: " + self.id)
		
func _add_lunge_boost(character: CharacterBase):
	assert(character is PlayerObject)
	character.inventory_component.add_item(self)
	if GameManager.is_touch_joypad_enabled:
		(character as PlayerObject).mobile_joypad.show_touch_dash_button()
