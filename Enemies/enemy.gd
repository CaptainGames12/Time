extends CharacterBody2D
class_name Enemy

@export var health = 100
@export var SPEED = 100

@onready var animation: AnimatedSprite2D = $Animation
@onready var nav: NavigationAgent2D = $NavigationAgent2D

@onready var healthbar: ProgressBar = $ProgressBar
@onready var attack_animation_player: AnimationPlayer = $AnimationPlayer


var coin = preload("res://shopping/coin.tscn").instantiate()
var treasure: Sprite2D

var restart_ui: Control
var knock_speed = 50
		
var player = null

var treasure_distance: Vector2 
var player_distance: Vector2
var is_tres_closer: bool = false
var final_direction
var tick : int = 0

var confused: bool = false

var tornado_direction: Vector2 

signal dead

func _ready() -> void:
	healthbar.max_value = health
	healthbar.value = health
	dead.connect($"..".enemy_death)
	restart_ui = get_parent().get_node("CanvasLayer/TimeControl/RestartUI")

func spawn_coin_and_free():
	get_parent().call_deferred("add_child", coin)
	coin.position = position
	queue_free()
	
func _on_detection_body_entered(body):
	if body.name=="Player":
		player = body	

func random_vector():
	return Vector2(randi_range(-1, 1), randi_range(-1, 1))
	
func move_to_target(target, delta):
		if tick >= 30  or !confused :
			nav.target_position = target.position
			final_direction = nav.get_next_path_position() - global_position
			final_direction = final_direction.normalized() if !confused else random_vector()

			velocity = velocity.lerp(final_direction*SPEED*delta, 1)
			tick = 0

func finding_target():
	treasure_distance = (treasure.position - position)
	player_distance = (player.position - position)  
	is_tres_closer = treasure_distance.length()<player_distance.length()
func moving_animate():
	if velocity.length_squared()>0:
		animation.flip_h=velocity.x>0
		animation.play("walking")
	else:
		animation.play("idle")	

		
func _physics_process(delta):
	healthbar.value = health

	if health<=0:
		spawn_coin_and_free()
		emit_signal("dead")	
	if player!=null and treasure != null:
		finding_target()
	if is_tres_closer and treasure != null:
		move_to_target(treasure, delta)
	elif !is_tres_closer and player != null:
		move_to_target(player, delta)
	moving_animate()
	
	tick += 1

	move_and_collide(velocity)

func winded(attack_direction):
	velocity+=attack_direction*knock_speed	

func frozen():
	SPEED = 0
	await get_tree().create_timer(4).timeout
	SPEED = 100	
		
func watered():
	SPEED = 50
	await get_tree().create_timer(4).timeout
	SPEED = 100
	
func fired():
	for i in range(4):
		await get_tree().create_timer(1).timeout
		health-=2

func hitting_player():
	Global.hp-=1
	attack_animation_player.play("attack")
	
func player_free(body):
	for i in get_parent().get_node("CanvasLayer").get_children():
		for j in i.get_children():
			if j.name!="RestartUI":
				j.queue_free()

	
	body.queue_free()
	game_over_anim()
	
func game_over_anim():
	get_parent().get_node("CanvasLayer/TimeControl/RestartUI/Clock").game_over=true
	$"../Sprite2D".global_position=treasure.position
	$"../Sprite2D".visible=true
	var tween = get_tree().create_tween()
	tween.set_pause_mode(2)
			
	tween.tween_property($"../Sprite2D", "scale", Vector2(60, 60), 3)
	get_parent().get_node("MainMusic").stream=preload("res://Wizard/game_over_without_ticking.mp3")
	get_parent().get_node("MainMusic").process_mode = Node.PROCESS_MODE_ALWAYS
	tween.finished.connect(get_parent().get_node("MainMusic").play)
	get_tree().paused = true
	restart_ui.visible = true
	tween.tween_property(restart_ui, "modulate", Color(1, 1, 1, 1), 2)
	tween.finished.connect(tween.kill)
	tween.finished.connect(turn_on_restart)
func turn_on_restart():
	restart_ui.get_node("RestartButton").action="restart"
func _on_attack_body_entered(body:Node2D)->void:
	if body.is_in_group("player"):
		hitting_player()
		if Global.hp <= 0:
			player_free(body)
