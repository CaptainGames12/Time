extends CharacterBody2D
class_name ClockBoss

var isAngried = false
@onready var player = get_node("/root/Node2D/Player")
var isProtected=true
@onready var clock_boss_sprite: AnimatedSprite2D = $Animation
@onready var defense: Sprite2D = $Defense
@onready var restart_ui: Control
var target_pos = Vector2(0,0)
var SPEED = 20
var ROT_SPEED = 300
var master_dialog = preload("res://ui/dialog/dialogs.tscn").instantiate()
var counter=0
@export var health = 20:
	set(value):	
		if value<=0 and counter==0:
			counter+=1
			$Collision.disabled=true
			if phrases!=null:	
				phrases.queue_free()
			health=value
			get_parent().get_node("Treasure").the_end_of_forest()
			get_parent().get_node("CanvasLayer").add_child(master_dialog)
			
			clock_boss_sprite.animation_finished.connect(queue_free)
			
			clock_boss_sprite.play("death")
			
		else:
			health=value	
signal hit_player
signal stopHit
@onready var stop_vector: RayCast2D = get_node("/root/Node2D/StopVec")
@onready var locator: Area2D = $Locator
@onready var rolling_time: Timer = $RollingTime
@onready var locator_sprite: Sprite2D = $"Locator sprite"
@onready var shooting_cooldown: Timer = $ShootingCooldown
@onready var phrases = preload("res://Enemies/boss/dialog/angryclockdialog.tscn").instantiate()	
const BOSS_ATTACK = preload("res://Enemies/boss/boss_attack.tscn")
enum States
{
	IDLE, 
	ROLLING
}
var state = States.IDLE
var atk_dir:Vector2 = Vector2(0, 0)
var isWinded = false
var spawnRock = false
var knock_speed=50
var rockNode = preload("res://spells/earth/rock.tscn").instantiate()
		
func states_changer(newState):
	state=newState
func rolling_animate(delta):
	if velocity.x<0:
		rotation_degrees-=ROT_SPEED*delta
	if velocity.x>0:
		rotation_degrees+=ROT_SPEED*delta
	if isAngried:
		if health>=0:
			clock_boss_sprite.play("angry")
			defense.visible = false
func rolling_physics(delta):
	if isAngried:
		if get_tree().paused==false:
			PhysicsServer2D.set_active(true)
			SPEED=20
			velocity -= target_pos*SPEED*delta
			isProtected = false
			print("rolling")
		elif get_tree().paused == true:
			PhysicsServer2D.set_active(true)
			SPEED=5
			velocity -= target_pos*SPEED*delta
		if isWinded:
			velocity+=atk_dir*knock_speed	
			isWinded = false
func get_direction_rolling(body):
	locator.set_deferred("monitoring", false)
	target_pos = (position-body.position).normalized()
	player = body
	isAngried = true
func shooting():
	if player!=null and shooting_cooldown.is_stopped():	
		var arrow_node = BOSS_ATTACK.instantiate()
		arrow_node.rotation=position.angle_to_point(player.position)
		get_parent().add_child(arrow_node)
		arrow_node.position = position
		arrow_node.target_fire = (position-player.position).normalized()
		shooting_cooldown.start()
		if player.position.x>=position.x:
			clock_boss_sprite.flip_h = true
		else:
			clock_boss_sprite.flip_h = false

func _process(delta: float) -> void:
	match state:
		States.IDLE:
			if health>=0:
				defense.visible = true
				clock_boss_sprite.play("not angry")
				rotation_degrees=0
				shooting()
		States.ROLLING:
			rolling_animate(delta)
func _ready() -> void:
	Texts.place=10
	get_parent().get_node("CanvasLayer").add_child(phrases)
	get_parent().get_node("MainMusic").playing=false
	stopHit.connect(stopHitEmited)
	scale.x = 4
	scale.y = 4
	$RemoteTransform2D.remote_path = stop_vector.get_path()
	position = Vector2(1878, 580)
	var tween_walking = get_tree().create_tween()
	tween_walking.tween_property(self, "global_position", Vector2(1650,580),2)
	#tween_walking.finished.connect(walked)

func stopHitEmited():

	isAngried = false
	
	rolling_time.start()
	target_pos = Vector2.ZERO
	velocity = Vector2.ZERO
	isProtected = true
	states_changer(States.IDLE)
func _physics_process(delta: float) -> void:
	
	match state:
		States.ROLLING:
			rolling_physics(delta)
	stop_vector.target_position=velocity.normalized()*50
		
	if stop_vector.is_colliding() or stop_vector.collide_with_areas:
		print("is_colliding")
		
		emit_signal("stopHit")
	move_and_collide(velocity)

func _on_attack_body_entered(body: Node2D) -> void:
	if body is Player:
		Global.hp-=2
		body.healthbar.value-=2
		emit_signal("hit_player", velocity)
		finishing_player(body)
	elif body.is_in_group("tree"):
		
		body.queue_free()
		health -=2
		
func finishing_player(body):
	restart_ui =get_parent().get_node("CanvasLayer/TimeControl/RestartUI")
	
	
	if Global.hp <= 0:
		if restart_ui!=null:
			for i in get_parent().get_node("CanvasLayer").get_children():
				for j in i.get_children():
					if j.name!="RestartUI":
						j.queue_free()
			body.queue_free()
			get_tree().paused = true
			restart_ui.visible = true
		game_over_anim()
	
func game_over_anim():
	get_parent().get_node("CanvasLayer/TimeControl/RestartUI/Clock").game_over=true
	get_parent().get_node("Sprite2D").global_position=get_parent().get_node("Treasure").position
	get_parent().get_node("Sprite2D").visible=true
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
func _on_locator_body_entered(body: Node2D) -> void:
	if rolling_time.is_stopped() and body is Player:
		get_direction_rolling(body)
		isProtected=false
		states_changer(States.ROLLING)	
		locator_sprite.visible = false

func _on_rolling_time_timeout() -> void:

	locator_sprite.visible = true
	locator.set_deferred("monitoring", true)
func winded(direction):
	atk_dir = direction
	isWinded = true

func watered():
	SPEED = 5
	await get_tree().create_timer(4).timeout
	SPEED = 20
func fired():
	for i in range(4):
		await get_tree().create_timer(1).timeout
		health-=2
		if i==4:
			get_child(0).queue_free()
