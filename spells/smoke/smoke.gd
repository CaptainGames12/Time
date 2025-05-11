extends Area2D

func _ready() -> void:
	await get_tree().create_timer(4).timeout
	
	queue_free()
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		
		body.health-=1
		$"../AnimationPlayer".play("collide")
