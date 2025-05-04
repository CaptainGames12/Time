extends Node2D
@export var radius := 15
@export var finger_id := -1
var dragging := false
var knob_start_pos := Vector2.ZERO
var input_vector := Vector2.ZERO
var knocked = false
func _ready():
	
	knob_start_pos = $Stick.position

func _input(event):
	if event is InputEventScreenTouch:
		if event.pressed and finger_id == -1 and is_point_inside(event.position):
			finger_id = event.index
			dragging = true
			_update_knob(event.position)
			Input.action_press("attack")
		elif not event.pressed and event.index == finger_id:
			finger_id = -1
			dragging = false
			input_vector = Vector2.ZERO
			$Stick.position = knob_start_pos

	elif event is InputEventScreenDrag and event.index == finger_id:
		_update_knob(event.position)

func _update_knob(pos):
	if !knocked:	
		var dir = (pos - global_position).limit_length(radius)
		input_vector = dir / radius
		$Stick.position = knob_start_pos + dir
	# input_vector можна використовувати для управління гравцем

func is_point_inside(pos: Vector2) -> bool:
	return $Ring.get_global_rect().has_point(pos)
