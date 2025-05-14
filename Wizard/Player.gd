class_name Player 
extends CharacterBody2D
var SPEED = 300
var in_the_shop = false
var last_facing_dir = Vector2(0, -1)
var cooldown_finished = true
var knockback_power: Vector2 = Vector2.ZERO
var attacked=false
@onready var collect_coin: AudioStreamPlayer2D = $Collect_coin
@onready var joystick: Node2D = %Joystick
@onready var spell_joystick: Node2D = %SpellJoystick
@onready var animation_tree: AnimationTree = $AnimationTree

@export var inv_res:Inv
@onready var score= Global.score
@onready var restart_ui: Control = %RestartUI
@onready var dialogs: Control = %Dialogs
		
@onready var attack_node = preload("res://Wizard/attack/attack.tscn")

@onready var money: Label = %AmountOfMoney
@onready var cooldown_timer: Timer = %Cooldown_timer
@onready var main = $".."
@onready var inventory = %InventoryUI
@onready var stamina: TextureProgressBar = %Stamina
@onready var timer: Timer = %Stamina_timer
@onready var healthbar:= %Health

func _ready() -> void:
	
	animation_tree.active=true
	healthbar.max_value =10
	healthbar.value = 10
	Global.hp = healthbar.value
	healthbar.value = Global.hp

func _input(event: InputEvent) -> void:
	
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
func _process(delta: float) -> void:
	var idle = !velocity.normalized()
	if !idle:
		last_facing_dir= velocity.normalized()
	$Move.visible = !attacked
	$Attack.visible = attacked
	animation_tree.set("parameters/Walk/blend_position", last_facing_dir)
	animation_tree.set("parameters/Idle/blend_position", last_facing_dir)

func _physics_process(delta):
	if Global.hp==0:
		$"../TextureRect".visible=true
	healthbar.value=Global.hp	
	money.text = str(score)
	velocity = joystick.input_vector*SPEED
	velocity+=knockback_power
	velocity.normalized()
	
	move_and_slide()

func attack(touch_pos):
	var bullet = attack_node.instantiate()
	
	if null != inventory.chosen_item.values():
		
		bullet.look_at(touch_pos)
		
		bullet.elements = inventory.chosen_item
		get_parent().add_child(bullet)
		
		bullet.position = position
		bullet.target_fire = touch_pos.normalized()
		

func _on_stamina_timer_timeout() -> void:
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
	knockTween.finished.connect(knockback_finished)
func knockback_finished():
	joystick.knocked=false
func collect(item):
	inv_res.insert(item)
func _on_cooldown_timer_timeout() -> void:
	cooldown_finished = true	

func _on_time_stop_pressed() -> void:
		if dialogs==null and !in_the_shop:
			get_tree().paused = !get_tree().paused
			timer.start()
			$AudioStreamPlayer2D.play()
		DialogSignals.time_stop_pressed.emit()
