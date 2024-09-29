extends CanvasLayer

func _ready():
	$PanelPoints/HBoxContainer/Points.text = ": %09d" % [GameManager.get_points()]
	GameManager.on_change_points.connect(_on_points_changed)
	$PanelTime/Time.text = "Time: %02d:%02d" % [GameManager.max_game_time, 0]
	GameManager.on_change_time_left.connect(_on_time_changed)
	$DebugPanelMonsters.visible = GameManager.is_debug_enabled
	$ShopScene.on_button_close_clicked.connect(_on_close_shop_scene)
	if (GameManager.is_debug_enabled):
		GameManager.on_change_spawn_number.connect(_on_monster_spawned_number_changed)
		

func _on_monster_spawned_number_changed(new_number_monster_spawned: int):
	$DebugPanelMonsters/NumberMonsters.text = "Monsters:\n%03d" % new_number_monster_spawned

func _on_points_changed(new_points: int):
	$PanelPoints/HBoxContainer/Points.text = ": %09d" % [new_points]
	
func _on_time_changed(new_time_left: float):
	var sec = fmod(new_time_left, 60.0)
	var mnt = int(new_time_left / 60)
	$PanelTime/Time.text = "Time: %02d:%02d" % [mnt, sec]

func _on_button_buy_pressed():
	if not get_tree().paused:
		%ButtonBuy.disabled = true
		%ButtonPause.disabled = true
		$AnimationPlayer.play("On_Pause")
		await $AnimationPlayer.animation_finished
		get_tree().paused = true
	$ShopScene.open_window()

func _on_button_pause_pressed():
	%ButtonBuy.disabled = true
	%ButtonPause.disabled = true
	if not get_tree().paused:
		$AnimationPlayer.play("On_Pause")
	else:
		$AnimationPlayer.play("On_Unpause")
		%ButtonPause.release_focus()
	await $AnimationPlayer.animation_finished
	get_tree().paused = not get_tree().paused
	%ButtonPause.disabled = false
	%ButtonBuy.disabled = false

func _on_close_shop_scene():
	if not %ButtonPause.is_pressed():
		$AnimationPlayer.play("On_Unpause")
		await $AnimationPlayer.animation_finished
		get_tree().paused = false
	%ButtonPause.disabled = false
	%ButtonBuy.disabled = false
	
