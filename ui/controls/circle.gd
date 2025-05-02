extends Sprite2D
var button = 1
var pressed:bool
var max_distance = 15
@onready var joystick: Node2D = $".."

var touch_pos:Vector2
const deadzone =5
func _ready() -> void:
	max_distance*=joystick.scale.x
	touch_pos = joystick.pos
func _process(delta: float) -> void:
	if pressed:
		if touch_pos.distance_to(joystick.global_position)<=max_distance:
			global_position = touch_pos
			
		else:
			var angle = joystick.global_position.angle_to_point(touch_pos)
			global_position.x = joystick.global_position.x+cos(angle)*max_distance
			global_position.y = joystick.global_position.y+sin(angle)*max_distance
			
		calculateVector()
	else:
		global_position = lerp(global_position, joystick.global_position, delta*10)
	
		joystick.dirVec = Vector2.ZERO
func calculateVector():
	if abs(global_position.x-joystick.global_position.x)>=deadzone:
		joystick.dirVec.x = (global_position.x-joystick.global_position.x)/max_distance
	if abs(global_position.y-joystick.global_position.y)>=deadzone:
		joystick.dirVec.y = (global_position.y-joystick.global_position.y)/max_distance
func _on_button_button_down() -> void:
	pressed = true

func _on_button_button_up() -> void:
	pressed = false
