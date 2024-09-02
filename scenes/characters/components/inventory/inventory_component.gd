extends Node
class_name InventoryComponent

var items: Dictionary = {}

func add_item(item: ShopResourceBase) -> void:
	items[item.id] = true
	
func remove_item(item: ShopResourceBase) -> void:
	items[item.id] = false
