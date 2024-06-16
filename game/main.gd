extends Node

@onready var game_ui: CanvasLayer = $GameUI
@export var game_over_ui: PackedScene

var time_lapsed: float = 0.0

func _ready():
	if not GameManager.is_touch_joypad_enabled:
		$MobileJoypad.queue_free()
		
func trigger_game_over():
	if game_ui:
		var game_over_ui = game_over_ui.instantiate()
		add_child(game_over_ui)
		game_ui.queue_free()
		game_ui = null
		
func _process(delta):
	if GameManager.is_game_over:
		trigger_game_over()
