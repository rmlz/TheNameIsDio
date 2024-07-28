extends GridContainer
class_name StatusComponent

const STATUS_UI = preload("res://scenes/characters/components/Status/StatusScene.tscn")

func add_status(status: Status, target: CharacterBase) -> void:
	var stackable := status.stack_type != Status.StackType.NONE
	
	# New status is new to character
	if not _has_status(status.id):
		var new_status_ui := STATUS_UI.instantiate() as StatusScene
		add_child(new_status_ui)
		new_status_ui.add_child(status)
		new_status_ui.status = status
		new_status_ui.status.status_applied.connect(_on_status_applied)
		new_status_ui.status.initialize_status(target)
		return
	
	# New status is unique
	if not status.can_expire and not stackable:
		return
	
	# New status is stackable (intensity)
	if status.stack_type == Status.StackType.INTENSITY:
		var number_of_stacks
		var owned_status = _get_status(status.id)
		owned_status.stacks += status.add_stacks
		return
	
	# New istatus is stackable (duration)
	if status.can_expire and status.stack_type == Status.StackType.DURATION:
		_get_status(status.id).duration += status.duration
	
func _has_status(id: String) -> bool:
	for status_ui: StatusScene in get_children():
		if status_ui.status.id == id:
			return true
	
	return false
	
func _get_status(id: String) -> Status:
	for status_ui: StatusScene in get_children():
		if status_ui.status.id == id:
			return status_ui.status
	
	return null
	
func _get_all_statuses() -> Array[Status]:
	var statuses: Array[Status] = []
	for status_ui: StatusScene in get_children():
		statuses.append(status_ui.status)
	
	return statuses

func _on_status_applied(status: Status) -> void:
	if status.can_expire:
		status.duration -= 1
		status.stacks -= 1
