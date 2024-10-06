extends CharacterBody2D
var SPEED = 300
func _process(delta):
	velocity.x = (Input.get_action_strength("right")-Input.get_action_strength("left"))*SPEED
	velocity.y = (Input.get_action_strength("down")-Input.get_action_strength("up"))*SPEED
	velocity.normalized()
	var mouse_pos = get_global_mouse_position()
	var mouse_button_pressed = Input.is_action_just_pressed("mouse")
	match mouse_button_pressed:
		1:
			attack(mouse_pos)
	
	move_and_slide()
func attack(mouse):
	get_tree().add_child("res://fireball.tscn")
	$Fireball.position = position
	$Fireball.position+=mouse
