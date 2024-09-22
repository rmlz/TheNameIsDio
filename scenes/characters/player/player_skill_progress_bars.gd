extends Control
class_name PlayerSkillProgressBars

signal on_ritual_timer_timeout

@export_category("BarColors")
@export var bar_colors: Array[SkillBarColor] = []
var color_list_index = 0

func _process(delta):
	for item: Node in $GridContainer.get_children():
		if item is ProgressBar:
			var prog_bar: ProgressBar = item
			var timer: Timer = prog_bar.get_child(0)
			item.value = timer.time_left / timer.wait_time * 100

func add_ritual(item: ShopResourceBase):
	var bar: ProgressBar = _setup_bar()
	var timer: Timer = _setup_ritual_timer(item.cooldown, item.scene)
	
	bar.add_child(timer)
	$GridContainer.add_child(bar)
	GameManager.change_points_by(-item.cost)
	_next_bar_index()

func _setup_ritual_timer(cool_down: int, scene: PackedScene) -> Timer:
	var timer: Timer = Timer.new()
	timer.wait_time = cool_down
	timer.autostart = true
	timer.timeout.connect(
		func():
			on_ritual_timer_timeout.emit(scene)
			timer.start(cool_down)
	)
	return timer
	
func _setup_bar() -> ProgressBar:
	var progress_bar: ProgressBar = ProgressBar.new()
	progress_bar.fill_mode = ProgressBar.FILL_END_TO_BEGIN
	progress_bar.show_percentage = false
	progress_bar.custom_minimum_size = Vector2(100,8)
	progress_bar.min_value = 0.0
	progress_bar.max_value = 100.0
	progress_bar.step = 1.0
	var stylebox_background = _get_style_box(bar_colors[color_list_index].background)
	var stylebox_fill = _get_style_box(bar_colors[color_list_index].fill)
	progress_bar.add_theme_stylebox_override(
		"background", stylebox_background)
	progress_bar.add_theme_stylebox_override(
		"fill", stylebox_fill)
		
	return progress_bar

func _get_style_box(color: Color) -> StyleBoxFlat:
	var style_box: StyleBoxFlat = StyleBoxFlat.new()
	style_box.bg_color = color
	return style_box
	
func _next_bar_index() -> void:
	var next_index = color_list_index + 1
	if next_index > bar_colors.size() - 1:
		next_index = 0
	color_list_index = next_index
