extends Area2D

@onready var shop: Node2D = $".."
var pause_state = true
func _ready() -> void:
	
	DialogSignals.connect("tutorial_finished", tutorial_finished)
func _on_body_entered(body):
	
	print("detects")
	body.in_the_shop = false
	if !pause_state:	
		body.stamina_timer.start()
	shop.shop_theme.stop()
	body.global_position = shop.any_main_pos
	
	get_tree().paused = pause_state
	DialogSignals.emit_signal("out_of_the_shop")
	get_parent().get_parent().out_of_the_shop.emit()
func tutorial_finished():
	pause_state = false
