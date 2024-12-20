extends Area2D
@export var speed = 200
var target_fire: Vector2
var COIN = preload("res://coin.tscn").instantiate()
func _physics_process(delta):
	position-=target_fire*speed*delta
	


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_body_entered(body):
	COIN.position = body.position
	
	body.queue_free()
	queue_free()
	get_parent().call_deferred("add_child", COIN)
	
