extends Sprite2D
@onready var player: Player = $"../Player"
@onready var restart_ui: Control = $"../Player/CanvasLayer/RestartUI"
@export var treasureDurability: int
@onready var durabilityBar: ProgressBar = $Durability

func _on_area_2d_body_entered(body: Area2D) -> void:
	if body.is_in_group("attack_area"):
		treasureDurability-=10
		durabilityBar.value = treasureDurability
		body.get_parent().animation_player.play("attack")
		if treasureDurability<=0:
			queue_free()
			if player != null:
				player.process_mode = PROCESS_MODE_PAUSABLE
			get_tree().paused = true
			restart_ui.visible = true
	
