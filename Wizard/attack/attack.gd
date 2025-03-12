extends Area2D

@export var item: InvItem
@export var speed: = 300

var target_fire: Vector2
var COIN = preload("res://shopping/coin.tscn").instantiate()

func _ready() -> void:
	$Sprite2D.texture = item.texture

func _physics_process(delta):
	position-=target_fire*speed*delta
	
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_body_entered(body: Enemy):
	body.health -= item.damage
	
	match item.item_name:
		"fire":
			body.fired()
		"water":
			body.watered()
		"earth":
			body.earthed()
		"wind":
			body.winded()
	queue_free()
