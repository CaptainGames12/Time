extends StaticBody2D
func fired():
	await get_tree().create_timer(4).timeout
	queue_free()	
