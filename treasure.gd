extends Sprite2D
@onready var player: Player = $"../Player"
@onready var restart_ui: Control = $"../Player/CanvasLayer/RestartUI"

func _on_area_2d_body_entered(body: Node2D) -> void:
	queue_free()
	if player != null:
		player.process_mode = PROCESS_MODE_PAUSABLE
	get_tree().paused = true
	restart_ui.visible = true
	
