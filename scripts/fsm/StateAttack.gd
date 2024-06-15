class_name StateAttack
extends State


func _ready():
	enemy = owner

func enter(_msg:= {}) -> void:
	enemy.animation_player.play("Attack")
	
func update(delta: float) -> void:
	pass

func do_attack() -> void:
	var bodies = enemy.attack_area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("player"):
			var player: PlayerObject = body
			var direction_to_player = (player.position - enemy.global_position).normalized()
			enemy.proccess_attack(player.position)

func _on_attack_animation_finished(anim_name):
	if anim_name == "Attack":
		state_machine.transition_to("StateCoolDown", {"cd_time": enemy._deal_damage_time_cooldown})
