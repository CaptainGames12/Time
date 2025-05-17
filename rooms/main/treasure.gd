extends Sprite2D
@onready var player: Player = $"../Player"
@onready var restart_ui: Control = %RestartUI
@export var treasureDurability: int
@onready var durabilityBar: ProgressBar = $Durability
var is_tutorial_started = false
func _on_area_2d_body_entered(body: Area2D) -> void:
	if body.is_in_group("attack_area"):
		treasureDurability-=10
		durabilityBar.value = treasureDurability
		body.get_parent().attack_animation_player.play("attack")
		if treasureDurability<=0:
			
			for i in get_parent().get_node("CanvasLayer").get_children():
				for j in i.get_children():
					if j.name!="RestartUI":
						j.queue_free()
			
			
			body.queue_free()
			get_tree().paused = true
			restart_ui.visible = true
			queue_free()
			if player != null:
				player.process_mode = PROCESS_MODE_PAUSABLE
			
