extends Node
class_name InventoryComponent

var arcane_amplifier: bool = false

func add_item(item: ShopItemResource) -> void:
	match item.id:
		"arcane_amplifier":
			arcane_amplifier = true
			var player = owner as PlayerObject
			player.melee_attack_component.attack_area.scale = Vector2(2, 1)
