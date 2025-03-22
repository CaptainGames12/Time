extends Area2D

@export var item: InvItem
@export var speed: = 500

var target_fire: Vector2
var COIN = preload("res://shopping/coin.tscn").instantiate()

func _ready() -> void:
	$Sprite2D.texture = item.texture

func _physics_process(delta):
	position-=target_fire*speed*delta
	
	
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_body_entered(body: CharacterBody2D):
	
	if body.is_class("Enemy"):
		body.health -= item.damage
		match item.item_name:
			"fire":
				body.fired()
			"water":
				body.watered()
			"earth":
				body.earthed()
			"wind":
				body.winded(target_fire)
	else:
		if !body.isProtected:
			body.boss_health -= item.damage
	queue_free()
