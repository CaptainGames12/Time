class_name Player 
extends CharacterBody2D
var SPEED = 300

@onready var collect_coin: AudioStreamPlayer2D = $Collect_coin
var in_the_shop = false
@export var inv_res:Inv
@onready var score= Global.score
@onready var restart_ui: Control = $CanvasLayer/RestartUI
@onready var dialogs: Control = $CanvasLayer/Dialogs
		
@onready var fireball = preload("res://Wizard/attack/attack.tscn")

@onready var price: Label = $CanvasLayer/Price
@onready var cooldown_timer: Timer = $Cooldown_timer
@onready var main = $".."
@onready var inventory = $CanvasLayer/Control
@onready var stamina: TextureProgressBar = $CanvasLayer/Stamina
@onready var timer: Timer = $Stamina_timer
@onready var healthbar:= $CanvasLayer/Health
var cooldown_finished = true
var knockback_power: Vector2 = Vector2.ZERO
var attacked=false
func _ready() -> void:
	
	animation_tree.active=true
	healthbar.max_value =10
	healthbar.value = 10
	Global.hp = healthbar.value
	healthbar.value = Global.hp
@onready var joystick: Node2D = $CanvasLayer/Joystick
@onready var spell_joystick: Node2D = $CanvasLayer/SpellJoystick
@onready var animation_tree: AnimationTree = $AnimationTree
var last_facing_dir = Vector2(0, -1)


func _physics_process(delta):
	if Global.hp==0:
		$"../TextureRect".visible=true
		
	price.text = str(score)
	velocity = joystick.input_vector*SPEED
	velocity+=knockback_power
	velocity.normalized()
	var idle = !velocity.normalized()
	if !idle:
		last_facing_dir= velocity.normalized()
	$Move.visible = !attacked
	$Attack.visible = attacked
	animation_tree.set("parameters/Walk/blend_position", last_facing_dir)
	animation_tree.set("parameters/Idle/blend_position", last_facing_dir)
	if Input.is_action_pressed("attack"):	
		if cooldown_timer.is_stopped():
			cooldown_timer.start()
		if cooldown_finished: 
			if spell_joystick.input_vector!=Vector2.ZERO:
				attack(spell_joystick.input_vector)
				cooldown_finished = false
				last_facing_dir=spell_joystick.input_vector.normalized()
				animation_tree.set("parameters/Attack/blend_position", spell_joystick.input_vector)
				attacked=true
			else: 
				attacked=false
	
	if Input.is_action_just_pressed("time_stop") and !in_the_shop:
		if dialogs==null:
			get_tree().paused = !get_tree().paused
			timer.start()
			$AudioStreamPlayer2D.play()
		DialogSignals.time_stop_pressed.emit()
		
	var current_anim:String
	
	move_and_slide()

func attack(touch_pos):
	var bullet = fireball.instantiate()
	
	if null != inventory.chosen_item.values():
		
		bullet.look_at(touch_pos)
		
		bullet.elements = inventory.chosen_item
		get_parent().add_child(bullet)
		
		bullet.position = position
		bullet.target_fire = touch_pos.normalized()
		

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
	joystick.knocked=true
	joystick.input_vector=Vector2.ZERO
	knockTween.finished.connect(anim_finished)
func anim_finished():
	joystick.knocked=false
func collect(item):
	inv_res.insert(item)
	
func _on_cooldown_timer_timeout() -> void:
	cooldown_finished = true	
	

	
