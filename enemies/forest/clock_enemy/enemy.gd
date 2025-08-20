extends CharacterBody2D
class_name Enemy
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
var counter = 0

@export var health = 100
	
@export var SPEED = 100

@onready var animation: AnimatedSprite2D = $Animation
@onready var nav: NavigationAgent2D = $NavigationAgent2D


@onready var attack_animation_player: AnimationPlayer = $AnimationPlayer


var coin = preload("res://shopping/coin.tscn").instantiate()
var treasure: Sprite2D

var restart_ui: Control

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
	dead.connect($"..".enemy_death)

func spawn_coin_and_free():
	SPEED=0

	emit_signal("dead")
	
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
			tick=0
func finding_target():
	treasure_distance = (treasure.position - position)
	player_distance = (player.position - position)  
	is_tres_closer = treasure_distance.length()<player_distance.length()
func moving_animate():
	if health>=0:
		if velocity.length_squared()>0:
			animation.flip_h=velocity.x>0
			animation.play("walking")
		else:
			animation.play("idle")	
					
func _physics_process(delta):

	if player!=null and treasure != null:
		finding_target()
	if is_tres_closer and treasure != null:
		move_to_target(treasure, delta)
	elif !is_tres_closer and player != null:
		move_to_target(player, delta)
	
	moving_animate()
	tick+=1
	move_and_collide(velocity)
	
func hitting(body: Node2D):
	if body.is_in_group("player"):
		SignalBus.health_changed.emit(-1, "health")
		attack_animation_player.play("attack")
		if body!=null:	
			body.get_node("Oof").play()
		if Global.hp <= 0:
			player_free(body)
	if body.is_in_group("treasure"):
		var treasure = body.get_parent()
		treasure.treasureDurability-=10
		treasure.durabilityBar.value = treasure.treasureDurability
		attack_animation_player.play("attack")
		print("crystal_attacked")
func player_free(body):
	if body!=null:
		body.process_mode=Node.PROCESS_MODE_PAUSABLE
		body.queue_free()
	

func _on_attack_body_entered(body:Node2D)->void:
	hitting(body)
		
	

		
