extends Area2D

@export var scene : String
@onready var shop: Node2D = $"../../Shop"


func _on_body_entered(body):
	$"../../CanvasLayer/Support/Heal".disabled=true
	body.in_the_shop=true
	body.stamina_timer.stop()
	body.global_position = shop.entrance_pos
	get_parent().get_parent().in_the_shop.emit()
	shop.shop_theme.play()
	get_tree().paused =true
	PhysicsServer2D.set_active(true)
	
