class_name StateChanrge
extends State

@export var charge_time_secs = 2
var input_vector: Vector2 = Vector2.ZERO
var can_charge: bool = false
var char_collision_shape: CollisionShape2D
var timer: SceneTreeTimer

func enter(_msg:= {}) -> void:
	char_collision_shape = character.get_node("CollisionShape2D")
	character.animation_player.play("Start_Walk")
	var player_position: Vector2 = GameManager.player_position
	var difference: Vector2 = player_position - character.position
	input_vector = difference.normalized()
	rotate_sprite(input_vector)
	timer = get_tree().create_timer(charge_time_secs)
	timer.timeout.connect(_on_charge_timer_ends)
	
func update(_delta: float) -> void:
	if can_charge:
		character.collision_mask = pow(2, 32-1)
		character.velocity = input_vector * character._speed * 300
		if character.is_range_to_attack_player() != 0:
			character.collision_mask = pow(2, 1-1)
			timer.timeout.disconnect(_on_charge_timer_ends)
			_on_charge_timer_ends()
	else:
		character.velocity = Vector2.ZERO
	character.move_and_slide()
		
func _on_charge_timer_ends():
	can_charge = false
	character.animation_player.play("End_Walk")
	
func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Start_Walk":
		can_charge = true
		character.animation_player.play("Walk")
	if anim_name == "End_Walk":
		var type_attack = character.is_range_to_attack_player()
		if type_attack == 1 or type_attack == 2:
			state_machine.transition_to("StateAttack", {"type": type_attack})
		else:
			state_machine.transition_to("StateCoolDown", {
			"cd_time": character._deal_damage_time_cooldown,
			"hit": false, 
			"ignore_cd": false
			})
		
