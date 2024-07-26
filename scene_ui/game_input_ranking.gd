extends Control
class_name InputRank

@onready var text_edit: LineEdit = $TextEdit
@onready var submit_button: Button = $Submit
@onready var cancel_button: Button = $Cancel
@onready var loading_screen: Control = $Loading
@onready var error_label: Label = $Error

var confirm_cancel = false
var text_edit_mouse_entered = false

var initial_screen: PackedScene

func _ready():
	$Label2.text = "%09d points" % [GameManager.get_points()]
	loading_screen.hide()
	initial_screen = preload("res://scene_ui/game_start.tscn")

func _grab_focus():
	if not text_edit.has_focus():
		text_edit.grab_focus()
	var htmlAnswer = JavaScriptBridge.eval("prompt('%s');" % ["Please enter text"], true)
	if htmlAnswer:
		text_edit.text = htmlAnswer
		text_edit.release_focus()
		
func _input(event):
	if event is InputEventMouseButton and event.is_pressed() and text_edit_mouse_entered:
		_grab_focus()
		
		
	
func return_to_initial_screen():
	get_tree().change_scene_to_packed(initial_screen) 
	GameManager.reset()
	
func submit_rank() -> void:
	if validate_input():
		text_edit.editable = false
		submit_button.disabled = true
		loading_screen.show()
		%AnimationPlayer.play("loading")
		await send_rank_object()
		%Success.show()
		await get_tree().create_timer(2).timeout
		return_to_initial_screen()
	
func validate_input() -> bool:
	text_edit.text = text_edit.text.strip_edges()
	text_edit.text = text_edit.text.strip_escapes()
	if text_edit.text.length() < 3:
		error_label.text = "Use three characters!"
		return false
	return true
		

func send_rank_object():
	var collection: FirestoreCollection = Firebase.Firestore.collection("ranking")
	var data: Dictionary = {
		"version": GameManager.version,
		"score": int(GameManager.get_points()),
		"time": int(GameManager.time_elapsed),
		"name": text_edit.text
	}
	await collection.add("", data)
	
func _on_text_edit_text_submitted(_new_text):
	submit_rank()

func _on_cancel_pressed():
	if not confirm_cancel:
		cancel_button.text = "Confirm?"
		confirm_cancel = true
	else :
		return_to_initial_screen()


func _on_submit_pressed():
	submit_rank()


func _on_text_edit_mouse_entered():
	text_edit_mouse_entered = true


func _on_text_edit_mouse_exited():
	text_edit_mouse_entered = false
