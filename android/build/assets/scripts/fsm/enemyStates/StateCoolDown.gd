class_name StateCoolDown
extends State

var max_cd_time: float
var current_cd_time: float
var is_hit: bool = false

func enter(_msg:= {}) -> void:
	character.animation_player.play("Idle")
	max_cd_time = _msg["cd_time"]
	is_hit = _msg["hit"]
	if not _msg["ignore_cd"]:
		add_time(int(max_cd_time))
	
func update(delta: float) -> void:
	current_cd_time -= delta
	if is_hit:
		character.velocity = lerp(character.velocity, Vector2.ZERO, 0.05)
	else:
		character.velocity = Vector2.ZERO
	character.move_and_slide()
	if current_cd_time <= 0:
		state_machine.transition_to("StateIdle")
	
func add_time(time: int) -> void:
	current_cd_time += time
	

