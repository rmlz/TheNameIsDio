extends CanvasLayer
class_name RankingScene

@onready var linesContainer: VBoxContainer = %LinesContainer
@onready var next_button: Button = %Next
@onready var previous_button: Button = %Previous
@onready var return_button: Button = %Return
@onready var version_name: Label = %Version
@onready var loading_bar: ProgressBar = %LoadingBar
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@export var ranking_row: PackedScene
@export var availableVersions: PackedStringArray
var versionIndex = 0
	
func start_screen():
	_toggle_buttons()
	_query_ranking()

func _query_ranking():
	create_loading()
	var query: FirestoreQuery = (FirestoreQuery.new()
		.from("ranking")
		.where("version", FirestoreQuery.OPERATOR.EQUAL, availableVersions[versionIndex])
		.order_by("score", FirestoreQuery.DIRECTION.DESCENDING))
	
	var results: Array = await Firebase.Firestore.query(query)
	await end_and_close_loading()
	
	var ordinal = 1
	for doc: FirestoreDocument in results:
		var row: RankingRow = ranking_row.instantiate()
		row.ordinal = get_ordinal(ordinal)
		row.rank_name = FirestoreUtils.getString(doc, "name")
		row.score = FirestoreUtils.getInteger(doc, "score")
		row.time = FirestoreUtils.getInteger(doc, "time")
		linesContainer.add_child(row)
		ordinal += 1
		
func _toggle_buttons():
	previous_button.disabled = versionIndex == 0
	next_button.disabled = versionIndex == availableVersions.size() - 1
	version_name.text = availableVersions[versionIndex]
	if not previous_button.disabled:
		previous_button.grab_focus()
	elif not next_button.disabled:
		next_button.grab_focus()
	else:
		return_button.grab_focus()
	
func _clear_actual_ranking():
	for node in linesContainer.get_children():
		if node is RankingRow:
			node.queue_free()
			
func create_loading():
	loading_bar.visible = true
	for i in range(9):
		await get_tree().create_timer(0.1).timeout
		loading_bar.value = loading_bar.value + 10
		
func end_and_close_loading():
	loading_bar.value = 100
	await get_tree().create_timer(0.2).timeout
	loading_bar.visible = false
	loading_bar.value = 0
	

func get_ordinal(number) -> String:
	var suffix: String
	if 10 <= number % 100 and number % 100 <= 20:    
		suffix = 'th'
	else:
		suffix = {1: 'st', 2: 'nd', 3: 'rd'}.get(number % 10, 'th')
	return str(number) + suffix

func _on_previous_pressed():
	versionIndex = max(0, versionIndex -1)
	_toggle_buttons()
	_clear_actual_ranking()
	_query_ranking()

func _on_next_pressed():
	versionIndex = min(availableVersions.size() - 1, versionIndex + 1)
	_toggle_buttons()
	_clear_actual_ranking()
	_query_ranking()


func _on_return_pressed():
	animation_player.current_animation = "fade_out"
	animation_player.play()


func _on_animation_player_animation_finished(anim_name: String):
	if anim_name == "fade_out":
		get_tree().change_scene_to_file("res://scene_ui/game_start.tscn")
	elif anim_name == "fade_in":
		start_screen()
