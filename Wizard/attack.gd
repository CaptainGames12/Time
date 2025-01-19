extends Area2D

@export var item: InvItem
@export var speed: = 200

var target_fire: Vector2
var COIN = preload("res://shopping/coin.tscn").instantiate()

func _ready() -> void:
	
	$Sprite2D.texture = item.texture

func _physics_process(delta):
	position-=target_fire*speed*delta
	
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_body_entered(body):
	
	COIN.position = body.position
	body.health -=item.damage
	
	if body.health == 0:
		get_parent().call_deferred("add_child", COIN)
		body.queue_free()
		
	queue_free()
