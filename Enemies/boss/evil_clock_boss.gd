
extends CharacterBody2D

@export var boss_health = 20
var isAngried = false
var player=null
var isProtected=true
@onready var clock_boss_sprite: AnimatedSprite2D = $ClockBossSprite
@onready var defense: Sprite2D = $Defense
@onready var restart_ui: Control
var target_pos = Vector2(0,0)
var SPEED = 20
var ROT_SPEED = 200
signal hit_player
@onready var stop_vector: RayCast2D = $StopVector
@onready var locator: Area2D = $Locator
@onready var rolling_time: Timer = $RollingTime
@onready var locator_sprite: Sprite2D = $"Locator sprite"
@onready var shooting_cooldown: Timer = $ShootingCooldown
	
const BOSS_ATTACK = preload("res://Enemies/boss/boss_attack.tscn")
enum States
{
	IDLE, 
	ROLLING
}
var state = States.IDLE
func states_changer(newState):
	state=newState
func rolling_animate(delta):
	if target_pos.x<position.x:
		rotation_degrees-=ROT_SPEED*delta
	if target_pos.x>position.x:
		rotation_degrees+=ROT_SPEED*delta
	if isAngried:
		clock_boss_sprite.play("angry")
		defense.visible = false
func rolling_physics(delta):
	if isAngried:
		velocity -= target_pos*SPEED*delta
		isProtected = false
func get_direction_rolling(body):
	locator.get_child(0).disabled = true
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
func _process(delta: float) -> void:
	match state:
		States.IDLE:
			defense.visible = true
			clock_boss_sprite.play("not angry")
			rotation_degrees=0
			shooting()
		States.ROLLING:
			rolling_animate(delta)
func _ready() -> void:
	scale.x = 3
	scale.y = 3		
	
func _physics_process(delta: float) -> void:
	match state:
		States.ROLLING:
			rolling_physics(delta)
		
	move_and_collide(velocity)
func _on_attack_body_entered(body: Player) -> void:
	Global.hp-=2
	body.healthbar.value-=2
	emit_signal("hit_player", velocity)
	restart_ui = get_node("../Player/CanvasLayer/RestartUI")
	var main = get_parent()
	if Global.hp <= 0:
		restart_ui.get_parent().remove_child(restart_ui)
		main.add_child(restart_ui)
		body.queue_free()
		get_tree().paused = true
		restart_ui.visible = true

func _on_locator_body_entered(body: Node2D) -> void:
	if body.name=="Player" and rolling_time.is_stopped():
		get_direction_rolling(body)
		states_changer(States.ROLLING)	
	if body.name == "Barrier":
		states_changer(States.IDLE)
		locator_sprite.visible = false
		rolling_time.start()
		isAngried=false
		target_pos = Vector2.ZERO
		velocity = Vector2.ZERO
		isProtected = true

func _on_rolling_time_timeout() -> void:
	locator_sprite.visible = true
	locator.get_child(0).disabled = false
