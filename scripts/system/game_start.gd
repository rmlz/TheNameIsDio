extends CanvasLayer

@onready var start_button: Button = $ButtonPanel/StartButton
@onready var animation: AnimationPlayer = $FadeAnimation

func _on_start_button_pressed():
	animation.current_animation = "fade_out"
	animation.play()


func _on_fade_out_animation_finished(anim_name):
	if anim_name == "fade_out":
		GameManager.is_playing = true
		print("FOI")
		get_tree().change_scene_to_file("res://scenes/MainScene.tscn")
