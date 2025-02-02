extends CharacterBody2D
var treasure: Sprite2D
@onready var nav: NavigationAgent2D = $NavigationAgent2D
@export var health = 10

@export var speed = 200
@onready var health_bar: ProgressBar = $ProgressBar
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var restart_ui: Control
var COIN = preload("res://shopping/coin.tscn").instantiate()

var target = null
var targetIsHere = false
var attack = false
var tresDistance = null
var targetDistance = null
var dist = false

signal zero_hp
signal dead

func _ready() -> void:
	health_bar.max_value = health
	health_bar.value = health
	dead.connect($"..".enemy_death)
	
func death():
	get_parent().call_deferred("add_child", COIN)
	COIN.position = position
	queue_free()
	
func _on_detection_body_entered(body):
	target = body
	targetIsHere = true

func _process(delta):
	health_bar.value = health
	var direction
	if health<=0:
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
		
	move_and_slide()
func _on_detection_body_exited(body):
	target=null
	targetIsHere= false
	
func watered():
	speed = 100
	await get_tree().create_timer(4).timeout
	speed = 200
func fire():
	for i in range(4):
		print("function started %s" % str(i))
		await get_tree().create_timer(2).timeout
		health-=2
		print("function finished")
func _on_attack_body_entered(body):
	animation_player.play("attack")
	Global.hp-=1
	body.healthbar.value =Global.hp
	restart_ui = get_node("../Player/CanvasLayer/RestartUI")
	var main = get_parent()
	if Global.hp <= 2:
		restart_ui.get_parent().remove_child(restart_ui)
		main.add_child(restart_ui)
		body.queue_free()
		get_tree().paused = true
		restart_ui.visible = true
