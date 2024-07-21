extends Panel
class_name ShopItem

var item_resource: ShopItemResource

func setup(item: ShopItemResource):
	item_resource = item

func _ready():
	%Icon.texture = item_resource.icon
	%Title.text = item_resource.title
	%Description.text = item_resource.description
	%Cost.text = str(item_resource.cost)
