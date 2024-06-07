extends Node

func _ready():
	$Panel/Label.text = "Points: %09d" % [GameManager.points]
	
func _process(delta):
	$Panel/Label.text = "Points: %09d" % [GameManager.points]
