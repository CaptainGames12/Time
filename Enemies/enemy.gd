extends CharacterBody2D
class_name Enemy
var treasure: Sprite2D

@export var health = 10
@export var speed = 100

@onready var animation: AnimatedSprite2D = $Animation
@onready var nav: NavigationAgent2D = $NavigationAgent2D
@onready var health_bar: ProgressBar = $ProgressBar
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var restart_ui: Control
var COIN = preload("res://shopping/coin.tscn").instantiate()
var rockNode = preload("res://spells/earth/rock.tscn").instantiate()
		
var target = null
var targetIsHere = false
var attack = false
var tresDistance = null
var targetDistance = null
var dist = false

signal zero_hp
signal dead
var spawnRock = false
func _ready() -> void:
	health_bar.max_value = health
	health_bar.value = health
	dead.connect($"..".enemy_death)
	
func death():
	get_parent().call_deferred("add_child", COIN)
	COIN.position = position
	if spawnRock:
		get_parent().call_deferred("add_child", rockNode)
		rockNode.position.y = position.y
		rockNode.position.x = position.x+20
		print("rock_spawned")
	queue_free()
	
func _on_detection_body_entered(body):
	if body.is_in_group("target"):
		print("target is found")
		target = body
		targetIsHere = true
var atk_dir:Vector2 = Vector2(0, 0)
var isWinded = false
func _physics_process(delta):
	health_bar.value = health
	var direction
	
	print(health_bar.value)
	if health_bar.value<=1:
		death()
		emit_signal("dead")
		
	if target!=null and treasure != null:
		nav.target_position=target.position
		tresDistance = (treasure.position - position)
		targetDistance = (target.position - position)  
		dist = tresDistance<targetDistance
	if dist and treasure != null:
		direction = (treasure.position - position)
		direction = direction.normalized()
		velocity = velocity.lerp(direction*speed, 1)
	elif targetIsHere:
		nav.target_position=target.position
		direction = (nav.get_next_path_position() - global_position)
		direction = direction.normalized()
		velocity = velocity.lerp(direction*speed, 1)
	if isWinded:
		velocity-=atk_dir*knock_speed	
		isWinded = false
	if velocity!=Vector2(0, 0):
		if velocity.x<0:
			animation.flip_h = false
		if velocity.x>0:
			animation.flip_h = true
		animation.play("walking")
	else:
		animation.play("idle")
	move_and_slide()
var knock_speed = 5000
func winded(direction):
	atk_dir = direction
	isWinded = true
func earthed():
	spawnRock = true
		
func watered():
	speed = 50
	await get_tree().create_timer(4).timeout
	speed = 100
func fired():
	
	for i in range(4):
		
		await get_tree().create_timer(1).timeout
		health-=2
	
		if i==4:
			get_child(0).queue_free()
func _on_attack_body_entered(body:Player):
	animation_player.play("attack")
	Global.hp-=1
	var tween = create_tween()
	tween.tween_property(body.healthbar, "value", Global.hp, 0.5)
	
	restart_ui = get_node("../Player/CanvasLayer/RestartUI")
	var main = get_parent()
	if Global.hp <= 2:
		restart_ui.get_parent().remove_child(restart_ui)
		main.add_child(restart_ui)
		body.queue_free()
		get_tree().paused = true
		restart_ui.visible = true
