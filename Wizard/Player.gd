class_name Player 
extends CharacterBody2D
var SPEED = 300

@export var inv_res:Inv
@onready var score = Global.score
@onready var fireball = preload("res://Wizard/fireball.tscn")
@onready var sprite = $AnimatedSprite2D
@onready var price: Label = $CanvasLayer/Price
@onready var cooldown_timer: Timer = $Cooldown_timer
@onready var main = $".."
@onready var inventory = $CanvasLayer/Control
@onready var stamina: TextureProgressBar = $CanvasLayer/Stamina
@onready var timer: Timer = $Stamina_timer
@onready var healthbar:= $CanvasLayer/Health
var cooldown_finished = true
func _ready() -> void:
	healthbar.max_value =10
	healthbar.value = 10
	Global.hp = healthbar.value
	healthbar.value = Global.hp
	Global.score = score
func _process(delta):
	price.text = str(score)
	velocity.x = (Input.get_action_strength("right")-Input.get_action_strength("left"))*SPEED
	velocity.y = (Input.get_action_strength("down")-Input.get_action_strength("up"))*SPEED
	velocity.normalized()
	if Input.is_action_just_pressed("mouse"):
		cooldown_timer.start()
		if cooldown_finished: 
			attack()
			cooldown_finished = false
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
		#wbullet.dead.connect($"..".enemy_death)
		bullet.position = position
		bullet.target_fire = (position-get_global_mouse_position()).normalized()
var saved = false
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
	
func _on_cooldown_timer_timeout() -> void:
	cooldown_finished = true	
	

	
