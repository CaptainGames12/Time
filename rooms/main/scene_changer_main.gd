extends Area2D

@export var spell_joystick: Node2D
@export var save_button: Control
@export var heal: Control
@export var shop : Node2D 
@export var time_control_manager: Node 
@export var root_node: Node2D

func _on_body_entered(body):
	spell_joystick.process_mode=Node.PROCESS_MODE_PAUSABLE
	save_button.process_mode=Node.PROCESS_MODE_PAUSABLE
	heal.disabled=true
	time_control_manager.in_the_shop=true
	time_control_manager.stamina_timer.stop()
	body.global_position = shop.entrance_pos
	root_node.in_the_shop.emit()
	shop.shop_theme.play()
	get_tree().paused =true
	PhysicsServer2D.set_active(true)
	
