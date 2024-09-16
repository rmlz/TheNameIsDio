class_name MobileJoypad extends CanvasLayer

var touch_joy: TouchScreenButton
var touch_joy_size: Vector2 = Vector2.ZERO 
var touch_joy_center: Vector2
var touch_joy_radius: float = 0.0

var touch_hit_button: TouchScreenButton
var touch_dash_button:TouchScreenButton

var joystick_active: bool = false
var input_vector: Vector2 = Vector2.ZERO
var move_vector: Vector2 = Vector2.ZERO

var down: Dictionary = {"touch_joy": {"index": null}, "touch_hit": {"index": null}}

func _ready():
	touch_hit_button = $TouchHitButton
	touch_joy =$TouchJoy
	touch_dash_button = $TouchDashButton
	touch_joy_size = Vector2(
			touch_joy.texture_normal.get_width(),
			touch_joy.texture_normal.get_height()) * touch_joy.scale
	
	$InputHandle.visible = false
	
	var positioned_touch_joy_center = touch_joy.position + (touch_joy_size / 2)
	touch_joy_center = positioned_touch_joy_center
	touch_joy_radius = touch_joy_size.x - touch_joy_center.x
	
	touch_dash_button.hide()
	if not GameManager.is_debug_enabled:
		$Label.hide()
	
	
func _input(event):
	if event is InputEventScreenTouch or event is InputEventScreenDrag:
		if not touch_joy.is_pressed():
			down["touch_joy"] = {"index": null}
			$InputHandle.position = touch_joy_center
		elif (
				touch_joy.is_pressed() and down["touch_joy"]["index"] == null or
				touch_joy.is_pressed() and down["touch_joy"]["index"] == event.index
			):
			down["touch_joy"] = {"index": event.index}
			input_vector = calculate_move_vector(event.position)
			print(input_vector)
			joystick_active = true
			var distance_from_center = event.position - touch_joy_center
			if (abs(distance_from_center.x) <= touch_joy_radius and
				abs(distance_from_center.y) <= touch_joy_radius):
				$InputHandle.position = event.position
			else:
				$InputHandle.position = (input_vector * touch_joy_radius) + touch_joy_center
			
			move_vector = (
				input_vector * 
				$InputHandle.position.distance_to(touch_joy_center) / Vector2(touch_joy_radius, touch_joy_radius))
			print("TESTE")
			print(move_vector)
		if not touch_hit_button.is_pressed():
			down["touch_hit"] = {"index": null}
		elif touch_hit_button.is_pressed():
			down["touch_hit"] = {"index": event.index}
			Input.action_press("attack")
			print("HIT!")
		if not touch_dash_button.is_pressed():
			down["touch_dash"] = {"index": null}
		elif touch_dash_button.is_pressed():
			down["touch_dash"] = {"index": event.index}
			Input.action_press("dash")
			print("DASH!")
		
	
	if event is InputEventScreenTouch:
		if not touch_hit_button.is_pressed():
			Input.action_release("attack")
		if not touch_dash_button.is_pressed():
			Input.action_release("dash")
		if not touch_joy.is_pressed():
			input_vector = Vector2.ZERO
			move_vector = Vector2.ZERO
			Input.action_release("move_left")
			Input.action_release("move_right")
			Input.action_release("move_up")
			Input.action_release("move_down")
		$InputHandle.visible = joystick_active

func _physics_process(delta):
	$Label.text = str(down)
	if joystick_active:
		if move_vector.x > 0:
			Input.action_release("move_left")
			Input.action_press("move_right", absf((move_vector.x)))
		elif move_vector.x < 0:
			Input.action_release("move_right")
			Input.action_press("move_left", absf((move_vector.x)))
			
		if move_vector.y > 0:
			Input.action_release("move_up")
			Input.action_press("move_down", absf((move_vector.y)))
		elif move_vector.y < 0:
			Input.action_release("move_down")
			Input.action_press("move_up", absf((move_vector.y)))
	
		#emit_signal("use_move_vector", move_vector)

func calculate_move_vector(event_position) -> Vector2:
	return (event_position - touch_joy_center).normalized()
	
func vector_linear_to_exponential(v: Vector2) -> Vector2:
	var k: float = 0.5  # Ajuste este valor conforme necessário
	return Vector2(exp(k * v.x), exp(k * v.y))
	
func show_touch_dash_button() -> void:
	touch_dash_button.show()
