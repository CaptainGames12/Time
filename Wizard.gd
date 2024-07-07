extends CharacterBody2D
var SPEED = 300
func _process(delta):
	velocity.x = (Input.get_action_strength("right")-Input.get_action_strength("left"))*SPEED
	velocity.y = (Input.get_action_strength("down")-Input.get_action_strength("up"))*SPEED
	velocity.normalized()
	move_and_slide()
