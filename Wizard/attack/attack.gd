extends Area2D

@export var item: InvItem
@export var speed: = 500
@onready var boss_health: Control =$".."/Player/CanvasLayer/Boss_health

var target_fire: Vector2
var COIN = preload("res://shopping/coin.tscn").instantiate()

func _ready() -> void:
	$Sprite2D.texture = item.texture
	match item.item_name:
			"fire":
				AttackSfx.stream = item.audio
				AttackSfx.play()
				
			"water":
				pass
			"earth":
				pass
			"wind":
				pass
func _physics_process(delta):
	position-=target_fire*speed*delta
	
	
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_body_entered(body: CharacterBody2D):
	print(body.get_class())
	if body is Enemy:
		body.health -= item.damage
		match item.item_name:
			"fire":
				
				body.add_child(item.particle.instantiate())
				body.move_child(find_child("fire"), -1)
				body.fired()
			"water":
				body.watered()
			"earth":
				body.earthed()
			"wind":
				body.winded(target_fire)
	elif body is ClockBoss:
		if !body.isProtected:
			body.boss_health -= item.damage
			boss_health.get_child(0).value -= item.damage
			if body.boss_health<=0:
				body.queue_free()
	queue_free()
