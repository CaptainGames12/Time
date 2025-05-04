extends Area2D

@export var item: InvItem
@export var speed: = 500
@onready var boss_health: Control =$".."/Player/CanvasLayer/Boss_health

var target_fire: Vector2
var COIN = preload("res://shopping/coin.tscn").instantiate()

signal deadBoss
func _ready() -> void:
	print(target_fire)
	look_at(target_fire)
	if get_node("/root/Node2D/Player/CanvasLayer/Dialogs")!=null:
		process_mode=Node.PROCESS_MODE_ALWAYS
	$Sprite2D.texture = item.texture
	deadBoss.connect(get_node("/root/Node2D").the_end)
	DialogSignals.shoot.emit()
	match item.item_name:
		"fire":
			AttackSfx.stream = item.audio
			AttackSfx.play()
		"water":
			AttackSfx.stream = item.audio
			AttackSfx.play()
		"earth":
			AttackSfx.stream = item.audio
			AttackSfx.play()
		"wind":
			AttackSfx.stream = item.audio
			AttackSfx.play()
			rotation=0
func _physics_process(delta):
	position+=target_fire*speed*delta
	
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
				body.add_child(item.particle.instantiate())
				body.move_child(body.get_node("water"), -1)
				body.watered()
			"earth":
				body.earthed()
			"wind":
				body.winded(target_fire)
	elif body is ClockBoss:
		if !body.isProtected:
			body.boss_health -= item.damage
			boss_health.get_child(0).value -= item.damage
			match item.item_name:
				"fire":
					body.add_child(item.particle.instantiate())
					body.move_child(find_child("fire"), -1)
					body.fired()
				"water":
					body.add_child(item.particle.instantiate())
					body.move_child(body.get_node("water"), -1)
					body.watered()
				"earth":
					body.earthed()
				"wind":
					body.winded(target_fire)
			if body.boss_health<=0:
				body.queue_free()
				deadBoss.emit()
	if item.item_name != "earth":	
		queue_free()


func _on_timer_timeout() -> void:
	match item.item_name:
		"earth":
			var rockNode = preload("res://spells/earth/rock.tscn").instantiate()
			get_parent().add_child(rockNode)
			rockNode.position = position
			print("rock should spawn")
