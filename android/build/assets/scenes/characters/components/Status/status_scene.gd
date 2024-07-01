class_name StatusScene
extends Control

@onready var icon: TextureRect = $Icon
@onready var duration: Label = $Duration
@onready var stacks: Label = $Stacks

@export var status: Status : set = set_status

func set_status(new_status: Status) -> void:
	if not is_node_ready():
		await ready
		
	status = new_status
	icon.texture = status.icon
	duration.visible = status.stack_type == Status.StackType.DURATION
	stacks.visible = status.stack_type == Status.StackType.INTENSITY
	custom_minimum_size = icon.size
	
	if duration.visible:
		custom_minimum_size = duration.size
	if stacks.visible:
		custom_minimum_size = stacks.size
		
	if not status.status_changed.is_connected(_on_status_changed):
		status.status_changed.connect(_on_status_changed)
		
	_on_status_changed()
	
func _on_status_changed() -> void:
	if not status:
		return
		
	if status.stack_type == Status.StackType.DURATION and status.can_expire and status.duration <= 0:
		status.expire()
		queue_free()
		
	if status.stack_type == Status.StackType.INTENSITY and  status.stacks <= 0:
		status.expire()
		queue_free()
		
	duration.text = str(status.duration)
	stacks.text = str(status.stacks)
	
