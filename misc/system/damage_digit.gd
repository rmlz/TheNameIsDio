class_name DamageDigit
extends Node


var value: int = 0

func _ready():
	$Node2D/Label.text = str(value) 
