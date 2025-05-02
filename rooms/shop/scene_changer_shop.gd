extends Area2D

@onready var shop: Node2D = $".."
var pause_state = true
func _ready() -> void:
	
	DialogSignals.connect("tutorial_finished", tutorial_finished)
func _on_body_entered(body):
	
	print("detects")
	body.in_the_shop = false
	if !pause_state:
		body.timer.start()
	shop.shop_theme.stop()
	body.global_position = shop.any_main_pos
	shop.camera_2d.position = Vector2(579, 329)
	get_tree().paused = pause_state
	DialogSignals.emit_signal("out_of_the_shop")

func tutorial_finished():
	pause_state = false
