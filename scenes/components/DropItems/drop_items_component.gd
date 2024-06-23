class_name DropItemsComponent
extends Node

@export var min_drops = 0
@export var max_drops = 3
@export var drops: Array[PackedScene]

var enemy: EnemyBase

func _ready():
	await owner.ready
	enemy = owner

func drop_items() -> void:
	if (drops.size() > 0):
		var number_of_drops = randi_range(min_drops, max_drops) 
		for i in range(number_of_drops):
			var drop_index = randi_range(0, drops.size() - 1)
			var drop = drops[drop_index].instantiate()
			drop.position = enemy.global_position + Vector2(randi_range(-100, 100), randi_range(-100, 100))
			enemy.get_parent().add_child(drop)
