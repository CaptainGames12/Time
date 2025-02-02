extends Sprite2D


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		Global.score+=1
		body.score = Global.score
		queue_free()
