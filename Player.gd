class_name Player extends CharacterBody2D
var SPEED = 300
@onready var fireball = preload("res://fireball.tscn")
var window

	
	
func _process(delta):
	velocity.x = (Input.get_action_strength("right")-Input.get_action_strength("left"))*SPEED
	velocity.y = (Input.get_action_strength("down")-Input.get_action_strength("up"))*SPEED
	velocity.normalized()
	window = get_viewport_rect().size
	if Input.is_action_just_pressed("mouse"):
		attack()
	if Input.is_action_just_pressed("time_stop"):
		get_tree().paused = !get_tree().paused
	
		
	move_and_slide()
func attack():
	
	var bullet = fireball.instantiate()
	get_parent().add_child(bullet)
	bullet.position = position
	bullet.target_fire = (position-get_global_mouse_position()).normalized()
		
		
	
	



