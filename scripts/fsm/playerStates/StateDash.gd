class_name StateDashPlayer extends State

var input_vector: Vector2
const max_time_dashing: float = 0.6
var time_dashing: float = max_time_dashing
func enter(_msg:= {}) -> void:
	if (not _msg.has("lunge_boost") or not _msg["lunge_boost"]):
		state_machine.transition_to(
			"StateIdle"
		)
		return
	time_dashing = max_time_dashing
	input_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down", 0.15)
	character.animation_player.play("attack-side-2")
	
func update(_delta: float) -> void:
	time_dashing -= _delta
	rotate_sprite(input_vector)
	character.velocity = input_vector * character._speed * 200
	character.move_and_slide()
	
	if time_dashing < 0:
		state_machine.transition_to(
			"StateCoolDown", {
				"cd_time": 1,
				"hit": true,
				"ignore_cd": false
			}
		)
		
func do_attack() -> void:
	var player_position = GameManager.player_position
	character.proccess_attack(player_position, 1)
