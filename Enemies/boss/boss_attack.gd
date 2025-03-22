extends Area2D

@export var speed: = 500

var target_fire: Vector2


func _physics_process(delta):
	position-=target_fire*speed*delta
	
	
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_body_entered(body: Player):
	body.healthbar.value-=3
	queue_free()
