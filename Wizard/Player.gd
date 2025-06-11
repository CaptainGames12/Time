class_name Player 
extends CharacterBody2D
var SPEED = 300
var in_the_shop = false
var last_facing_dir = Vector2(0, -1)
var cooldown_finished = true
var knockback_power: Vector2 = Vector2.ZERO
var attacked=false
var save_path = "user://save.tres"
var saving = SaveGame.new()
var mat := preload("res://Wizard/hurt.tres") as ShaderMaterial
var health = Global.hp:
	set(value):
		if value<health:
			mat.set_shader_parameter("flash_strength", 1.0)
			await get_tree().create_timer(0.1).timeout
			mat.set_shader_parameter("flash_strength", 0.0)
			await get_tree().create_timer(0.1).timeout
			mat.set_shader_parameter("flash_strength", 1.0)
			await get_tree().create_timer(0.1).timeout
			mat.set_shader_parameter("flash_strength", 0.0)
			await get_tree().create_timer(0.1).timeout
			mat.set_shader_parameter("flash_strength", 1.0)
			await get_tree().create_timer(0.1).timeout
			mat.set_shader_parameter("flash_strength", 0.0)
		health=value
		healthbar.value = value
		
		
@onready var collect_coin: AudioStreamPlayer2D = $Collect_coin
@onready var joystick: Node2D = %Joystick
@onready var spell_joystick: Node2D = %SpellJoystick
@onready var animation_tree: AnimationTree = $AnimationTree

@export var inv_res:Inv

@onready var restart_ui: Control = %RestartUI
@onready var dialogs: Control = %Dialogs
		
@onready var attack_node = preload("res://Wizard/attack/attack.tscn")
@onready var entrance = $"../Entrances/any"
@onready var money = %Money
@onready var cooldown_timer: Timer = %Cooldown_timer
@onready var main = $".."
@onready var inventory = %InventoryUI
@onready var stamina: TextureProgressBar = %Stamina
@onready var stamina_timer: Timer = %Stamina_timer
@onready var healthbar:= %Health

@onready var saver = ResourceSaver
@onready var loader = ResourceLoader.load(save_path) as SaveGame
var switch =1
var ring_active := false
var start_time := 0
var ring_duration := 1000 # мілісекунд (1 секунда)

func trigger_ring():
	ring_active = true
	start_time = Time.get_ticks_msec()
	$"TimeStop".visible = true
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	animation_tree.active=true
	healthbar.max_value =10
	healthbar.value = 10
	Global.hp=10
	load_save()

func _process(delta: float) -> void:
	if ring_active:
		var now = Time.get_ticks_msec()
		var elapsed = now - start_time
		var progress = float(elapsed) / ring_duration
		$"TimeStop".material.set_shader_parameter("progress", progress)

		if progress >= 1.0:
			ring_active = false
			$"TimeStop".visible = false
	var idle = !velocity.normalized()
	if !idle:
		last_facing_dir= velocity.normalized()
	$TextureRect/Move.visible = !attacked
	$TextureRect/Attack.visible = attacked
	$Silhouette.visible = !attacked
	$SilhouetteAttack.visible = attacked
	animation_tree.set("parameters/Walk/blend_position", last_facing_dir)
	animation_tree.set("parameters/Idle/blend_position", last_facing_dir)
func shoot():
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
func _physics_process(delta):
	if get_tree().paused==true and dialogs==null and !in_the_shop:
			
			switch=1
	else:
			
			switch=0
		
	$"../ColorRect".material.set_shader_parameter("enabled", switch)
	if Global.hp<=0:
	
		SpellMixer.chosen_items=[null, null, null, null, null]
	
	health=Global.hp	
	%SaveButton.action="time_save"
	%TimeStop.action="time_stop"
	velocity = joystick.input_vector*SPEED
	velocity+=knockback_power
	if velocity==Vector2.ZERO:
		%Steps.stream_paused=true
	else:
		%Steps.stream_paused=false
	velocity.normalized()
	time_save()
	shoot()
	stop_time()
	move_and_slide()

func stop_time():
	if Input.is_action_just_pressed("time_stop"):
		
		if dialogs==null and !in_the_shop and %Treasure!=null:
				get_tree().paused = !get_tree().paused
				stamina_timer.start()
				%TimeStopSound.play()
				switch=!switch
				trigger_ring()
				

		DialogSignals.time_stop_pressed.emit()
func attack(touch_pos):
	var bullet = attack_node.instantiate()
	
	if null != SpellMixer.chosen_items:
		
		bullet.look_at(touch_pos)
		
		
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
func load_save():
	if loader != null:	
		
		global_position = loader.player_pos
		healthbar.value = loader.player_health
		
		get_parent().current_level = loader.level
		Global.collected_items = loader.collected_items
		Global.score = loader.global_score 
		Global.hp = loader.global_hp
		inventory.itemsList.slots = loader.player_inv
		inventory.update_slots()
		get_tree().paused=false
		
	else:
		global_position = entrance.global_position
		printerr("isn't loaded")	
func time_save() -> void:
	if Input.is_action_just_pressed("time_save"):
		if %Treasure!=null:
			if stamina.value==100:
				print("save")
				DialogSignals.time_save_pressed.emit()
				stamina.value = 0
				stamina_timer.start()
				
				saving.collected_items = Global.collected_items
				saving.player_pos = global_position
				saving.player_health = healthbar.value
				
				saving.global_score = Global.score
				saving.global_hp = Global.hp
				saving.level = get_parent().current_level
				saving.player_inv = inventory.itemsList.slots
				
				saver.save(saving, save_path)
		
