extends Control
class_name ShopScreen

@export var itens: Array[ShopItemResource] = []
@export var item_scene: PackedScene

func _ready():
	_instantiate_itens()
		
func _instantiate_itens() -> void:
	for item: ShopItemResource in itens:
		var scene: ShopItem = item_scene.instantiate()
		scene.setup(item)
		%ItemGrid.add_child(scene)
