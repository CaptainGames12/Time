extends Area2D
@export var spell_joystick: Node2D
@export var save_button: Control
@export var heal: Control
@export var root_node: Node2D
@export var time_control_manager: Node 
var pause_state = true
func _ready() -> void:
	
	DialogSignals.connect("tutorial_finished", change_pause_state)
func _on_body_entered(body):
	save_button.process_mode=Node.PROCESS_MODE_ALWAYS
	spell_joystick.process_mode=Node.PROCESS_MODE_ALWAYS
	
	heal.disabled=false
	print("detects")
	time_control_manager.in_the_shop = false
	if !pause_state:	
		time_control_manager.stamina_timer.start()
	root_node.shop_theme.stop()
	body.global_position = root_node.any_main_pos
	
	get_tree().paused = pause_state
	
	DialogSignals.emit_signal("out_of_the_shop")
	SignalBus.exited_the_shop.emit()
func change_pause_state():
	pause_state = false
