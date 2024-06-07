class_name BehaviorFollowPlayer
extends Node

var enemy: Enemy
var sprite: AnimatedSprite2D

func _ready():
	enemy = get_parent()
	sprite = enemy.get_node("AnimatedSprite2D")
	pass


func _physics_process(delta: float) -> void:
	var player_position = GameManager.player_position
	var difference: Vector2
	var input_vector: Vector2
	
	if enemy.update_damage_animation(delta):
		enemy.velocity = lerp(enemy.velocity, Vector2.ZERO, 0.05)
	else:
		enemy.end_damage_animation()
		difference = player_position - enemy.position
		input_vector = difference.normalized()
		rotate_sprite(input_vector)
		enemy.velocity = input_vector * enemy._speed * 100
	
	enemy.deal_damage(delta)
	enemy.move_and_slide()


func rotate_sprite(input_vector: Vector2) -> void:
	if input_vector.x > 0:
		sprite.flip_h = false
	elif input_vector.x < 0:
		sprite.flip_h = true
