class_name Player 
extends CharacterBody2D
var SPEED = 200

@onready var collect_coin: AudioStreamPlayer2D = $Collect_coin

@export var inv_res:Inv
@onready var score= Global.score
@onready var restart_ui: Control = $CanvasLayer/RestartUI
		
@onready var fireball = preload("res://Wizard/attack/attack.tscn")
@onready var sprite = $AnimatedSprite2D
@onready var price: Label = $CanvasLayer/Price
@onready var cooldown_timer: Timer = $Cooldown_timer
@onready var main = $".."
@onready var inventory = $CanvasLayer/Control
@onready var stamina: TextureProgressBar = $CanvasLayer/Stamina
@onready var timer: Timer = $Stamina_timer
@onready var healthbar:= $CanvasLayer/Health
var cooldown_finished = true
var knockback_power: Vector2 = Vector2.ZERO
func _ready() -> void:
	healthbar.max_value =10
	healthbar.value = 10
	Global.hp = healthbar.value
	healthbar.value = Global.hp

func _physics_process(delta):

	price.text = str(score)
	velocity.x = (Input.get_action_strength("right")-Input.get_action_strength("left"))*SPEED
	velocity.y = (Input.get_action_strength("down")-Input.get_action_strength("up"))*SPEED
	velocity+=knockback_power
	velocity.normalized()

	if Input.is_action_just_pressed("mouse"):
		if cooldown_timer.is_stopped():
			cooldown_timer.start()
		if cooldown_finished: 
			attack()
			cooldown_finished = false
	if Input.is_action_just_pressed("time_stop"):
		get_tree().paused = !get_tree().paused
		
		timer.start()
		$AudioStreamPlayer2D.play()
	var current_anim:String
	if velocity!=Vector2(0, 0):	
		if velocity.x < 0:
			sprite.flip_h = true
		if velocity.x > 0:
			sprite.flip_h = false
		sprite.play("run")
	else:
		
		sprite.play("idle")
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
		
func boss_hit(dir:Vector2):
	knockback_power +=dir.rotated(PI/2).normalized()*600

	var knockTween = get_tree().create_tween()
	knockTween.parallel().tween_property(self, "knockback_power", Vector2.ZERO, 0.5)
		
func collect(item):
	inv_res.insert(item)
	
func _on_cooldown_timer_timeout() -> void:
	cooldown_finished = true	
	

	
