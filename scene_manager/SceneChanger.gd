extends Area2D

@export var scene : String
@onready var shop: Node2D = $"../../Shop"

@onready var camera_2d: Camera2D = $"../../Player/CanvasLayer/Camera2D"

func _on_body_entered(body):

	body.in_the_shop=true
	body.timer.stop()
	body.global_position = shop.entrance_pos
	camera_2d.position = Vector2(589, -403)
	shop.shop_theme.play()
	get_tree().paused =true
	PhysicsServer2D.set_active(true)
	
