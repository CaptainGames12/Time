class_name Player 
extends CharacterBody2D
var SPEED = 300
@export var inv_res:Inv
@onready var score = 10
@onready var fireball = preload("res://Wizard/fireball.tscn")
@onready var sprite = $AnimatedSprite2D
@onready var label: Label = $CanvasLayer/Label

@onready var inventory = $CanvasLayer/Control
@onready var stamina: TextureProgressBar = $CanvasLayer/Stamina
@onready var timer: Timer = $Timer
@onready var healthbar:= $CanvasLayer/Health
func _ready() -> void:
	healthbar.max_value =10
	healthbar.value = 10
	
func _process(delta):
	label.text = str(score)
	velocity.x = (Input.get_action_strength("right")-Input.get_action_strength("left"))*SPEED
	velocity.y = (Input.get_action_strength("down")-Input.get_action_strength("up"))*SPEED
	velocity.normalized()
	
	if Input.is_action_just_pressed("mouse"):
		attack()
	if Input.is_action_just_pressed("time_stop"):
		get_tree().paused = !get_tree().paused
		timer.start()
		$AudioStreamPlayer2D.play()
	
	if velocity.x < 0:
		sprite.flip_h = true
	if velocity.x > 0:
		sprite.flip_h = false
	
	move_and_slide()
func attack():
	var bullet = fireball.instantiate()
	var angle = position.angle_to_point(get_global_mouse_position())
	if null != inventory.chosen_item:
		bullet.rotation= angle
		bullet.item = inventory.chosen_item
		get_parent().add_child(bullet)
		bullet.position = position
		bullet.target_fire = (position-get_global_mouse_position()).normalized()

func _on_timer_timeout() -> void:
	if get_tree().paused == true:
		match stamina.value>0:
			true:
				stamina.value-=10
			false:
				get_tree().paused = false
	if get_tree().paused == false:
		stamina.value+=10


func collect(item):
	inv_res.insert(item)
	print("collected")
	
