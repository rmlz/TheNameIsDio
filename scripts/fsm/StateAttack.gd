class_name StateAttack
extends State

var attack_type: int = 0
func _ready():
	enemy = owner

func enter(_msg:= {}) -> void:
	attack_type = _msg["type"]
	if attack_type == 1:
		enemy.animation_player.play("Melee_Attack")
	elif attack_type == 2:
		enemy.animation_player.play("Ranged_Attack")
	
func update(delta: float) -> void:
	pass

func do_attack() -> void:
	var player_position = GameManager.player_position
	enemy.proccess_attack(player_position, attack_type)

func _on_attack_animation_finished(anim_name):
	if anim_name == "Melee_Attack" or anim_name == "Ranged_Attack":
		state_machine.transition_to("StateCoolDown", {"cd_time": enemy._deal_damage_time_cooldown})
	attack_type = 0
