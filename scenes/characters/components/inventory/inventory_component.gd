extends Node
class_name InventoryComponent

var items: Dictionary = {}

func add_item(item: ShopResourceBase) -> void:
	items[item.id] = true
	if (GameManager.is_debug_enabled):
		print(items)
	
func remove_item(item: ShopResourceBase) -> void:
	items[item.id] = false
