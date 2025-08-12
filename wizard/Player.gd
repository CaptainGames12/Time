class_name Player 
extends CharacterBody2D

var speed = 300

var last_facing_dir = Vector2(0, -1)
var cooldown_finished = true
var knockback_power: Vector2 = Vector2.ZERO
var attacked=false

var hurt_mat := preload("res://wizard/hurt.tres") as ShaderMaterial


@onready var move_anim: Sprite2D = $WizardSprites/Move
@onready var attack_anim: Sprite2D = $WizardSprites/Attack
@onready var silhouette: Sprite2D = $Silhouette
@onready var silhouette_attack: Sprite2D = $SilhouetteAttack

@onready var collect_coin: AudioStreamPlayer2D = $Collect_coin
@export var joystick: Node2D 
@export var spell_joystick: Node2D
@onready var animation_tree: AnimationTree = $AnimationTree

@export var inv_res: Inv

@onready var attack_node = preload("res://wizard/attack/attack.tscn")
@export var cooldown_attack_timer: Timer
@onready var main = $".."

@export var healthbar: TextureProgressBar


func _ready() -> void:
	SignalBus.health_changed.connect(hurt_showing)
	process_mode = Node.PROCESS_MODE_ALWAYS
	animation_tree.active=true
	cooldown_attack_timer.timeout.connect(_on_cooldown_timer_timeout)
	Global.hp = 10
func _process(_delta: float) -> void:
	
	var idle = !velocity.normalized()
	if !idle:
		last_facing_dir= velocity.normalized()
	move_anim.visible = !attacked
	attack_anim.visible = attacked
	silhouette.visible = !attacked
	silhouette_attack.visible = attacked
	animation_tree.set("parameters/Walk/blend_position", last_facing_dir)
	animation_tree.set("parameters/Idle/blend_position", last_facing_dir)
func hurt_showing(value: int, type_of_value: String):
	if value < 0 and type_of_value == "health":
		var tween_hurt := get_tree().create_tween().chain()
		tween_hurt.tween_property(hurt_mat, "shader_parameter/flash_strength", 1, 0.2)
		tween_hurt.tween_property(hurt_mat, "shader_parameter/flash_strength", 0, 0.2)
		tween_hurt.finished.connect(tween_hurt.kill)
	
func shoot():
	if cooldown_attack_timer.is_stopped():
		cooldown_attack_timer.start()
		
	if cooldown_finished: 
			if spell_joystick.input_vector!=Vector2.ZERO:
				attack(spell_joystick.input_vector)
				cooldown_finished = false
				last_facing_dir=spell_joystick.input_vector.normalized()
				animation_tree.set("parameters/Attack/blend_position", spell_joystick.input_vector)
				attacked=true
			else: 
				attacked=false
func _physics_process(_delta):
	
	if Global.hp<=0:
		SpellMixer.chosen_items=[null, null, null, null, null]

	
	var x = (Input.get_action_strength("right")-Input.get_action_strength("left"))
	var y = (Input.get_action_strength("down")-Input.get_action_strength("up"))
	if joystick.input_vector.length()>0:	
		velocity = joystick.input_vector*speed
	elif Vector2(x, y).length()>0:	
		velocity = Vector2(x, y).normalized()*speed
	else:
		velocity = Vector2.ZERO
	velocity+=knockback_power
	
	if velocity==Vector2.ZERO:
		%Steps.stream_paused=true
	else:
		%Steps.stream_paused=false
	velocity.normalized()
	shoot()
	
	move_and_slide()

func attack(touch_pos):
	var bullet = attack_node.instantiate()
	
	if null != SpellMixer.chosen_items:
		
		bullet.look_at(touch_pos)
		get_parent().add_child(bullet)
		bullet.position = position
		bullet.target_fire = touch_pos.normalized()
		
func boss_hit(dir:Vector2):
	knockback_power += dir.rotated(PI/2).normalized()*600
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
