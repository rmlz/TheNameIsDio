extends CanvasLayer
class_name ShopScreen

@export var itens: Array[ShopItemResource] = []
@export var item_scene: PackedScene

signal on_item_button_buy_clicked
signal on_button_close_clicked

func _ready():
	hide()
	on_item_button_buy_clicked.connect(GameManager.on_buy_shop_item)
	_instantiate_itens()
	
func open_window() -> void:
	_update()
	%AnimationPlayer.play("open_shop_window")

func animate_items_open():
	for item: ShopItem in %ItemGrid.get_children():
		item.animate_open()
		
func animate_items_close():
	for item: ShopItem in %ItemGrid.get_children():
		item.animate_close()
		
func _instantiate_itens() -> void:
	for i: int in range(itens.size()):
		var scene: ShopItem = item_scene.instantiate()
		scene.setup(itens[i], i)
		scene._on_item_buy_button_clicked.connect(_on_button_buy_clicked)
		%ItemGrid.add_child(scene)
		
func _on_button_buy_clicked(item: ShopItemResource):
	on_item_button_buy_clicked.emit(item)
	_update()

func _update() -> void:
	%TotalPoints.text = "%09d" % GameManager.get_points()
	for shop_item: ShopItem in %ItemGrid.get_children():
		shop_item.update()
	
func _on_close_button_pressed():
	%AnimationPlayer.play("close_shop_window")
	await %AnimationPlayer.animation_finished
	for item: ShopItem in %ItemGrid.get_children():
		item.hide()
	on_button_close_clicked.emit()
