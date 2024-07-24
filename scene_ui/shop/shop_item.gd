extends Panel
class_name ShopItem

signal _on_item_buy_button_clicked
var item_resource: ShopItemResource
var idx: int = 0

func setup(item: ShopItemResource, index: int):
	idx = index
	item_resource = item

func _ready():
	%Icon.texture = item_resource.icon
	%Title.text = item_resource.title
	%Description.text = item_resource.description
	%Cost.text = str(item_resource.cost)
	update()

func animate_open() -> void:
	modulate.a = 0
	show()
	await get_tree().create_timer(idx * 0.25 + 0.25).timeout
	var tween = create_tween()
	tween.tween_property(
		self, "modulate", Color.WHITE, 0.5
	)

func animate_close() -> void:
	await get_tree().create_timer(idx * 0.25 + 0.25).timeout
	var tween = create_tween()
	tween.tween_property(
		self, "modulate", Color.TRANSPARENT, 0.25
	)

func _on_buy_button_pressed():
	if GameManager.get_points() >= item_resource.cost:
		_on_item_buy_button_clicked.emit(item_resource)
		item_resource.is_purchased = true
		update()

func update():
	%BuyButton.disabled = GameManager.get_points() < item_resource.cost or item_resource.is_purchased
	%PurchasedLabel.visible = item_resource.is_purchased
	
