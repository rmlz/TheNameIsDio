class_name StateCoolDown
extends State

var max_cd_time: float
var current_cd_time: float

func enter(_msg:= {}) -> void:
	enemy.velocity = Vector2.ZERO
	enemy.animation_player.play("Idle")
	max_cd_time = _msg["cd_time"]
	add_time(max_cd_time)
	
func update(delta: float) -> void:
	current_cd_time -= delta
	if current_cd_time <= 0:
		state_machine.transition_to("StateIdle")
	enemy.velocity = lerp(enemy.velocity, Vector2.ZERO, 0.05)
	enemy.move_and_slide()
	
func add_time(time: int) -> void:
	current_cd_time += time
	

