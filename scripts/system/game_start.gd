extends CanvasLayer

@onready var start_button: Button = $ButtonPanel/Control/StartButton
@onready var animation: AnimationPlayer = $FadeAnimation

func _ready():
	await Firebase.Auth.login_succeeded

func _process(_delta):
	if not start_button.has_focus():
		if Input.is_anything_pressed():
			start_button.grab_focus()
	

func _on_start_button_pressed():
	animation.current_animation = "fade_out"
	animation.play()


func _on_fade_out_animation_finished(anim_name):
	if anim_name == "fade_out":
		GameManager.is_playing = true
		get_tree().change_scene_to_file("res://scenes/MainScene.tscn")


func _on_check_button_toggled(toggled_on: bool) -> void:
	GameManager.is_touch_joypad_enabled = toggled_on
