extends Area2D

@onready var shop: Node2D = $".."

func _on_body_entered(body):
	print("detects")
	shop.shop_theme.stop()
	body.global_position = shop.any_main_pos
	shop.camera_2d.position = Vector2(579, 329)
	get_tree().paused = false
	
