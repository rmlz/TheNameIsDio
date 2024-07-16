class_name RitualShield
extends Ritual

func _start_prevent_damage():
	var player = get_parent()
	if player is PlayerObject:
		player.invicible = true
		
func _end_prevent_damage():
	var player = get_parent()
	if player is PlayerObject:
		player.invicible = false
