class_name StateAttackPlayer
extends State

var attack_type: int = 0
func _ready():
	character = owner

func enter(_msg:= {}) -> void:
	attack_type = 1
	character.animation_player.play("attack-side")
	
func update(_delta: float) -> void:
	pass

func do_attack() -> void:
	var player_position = GameManager.player_position
	character.proccess_attack(player_position, attack_type)

func _on_attack_animation_finished(anim_name):
	if anim_name == "attack-side":
		state_machine.transition_to("StateIdle")
	attack_type = 0
