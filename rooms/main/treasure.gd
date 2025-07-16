extends Sprite2D
@onready var player: Player = $"../Player"
@onready var restart_ui: Control = %RestartUI
@export var treasureDurability: int
@onready var durabilityBar: ProgressBar = $Durability
var is_tutorial_started = false
func _on_area_2d_body_entered(body: Area2D) -> void:
	if body.is_in_group("attack_area"):
		
		if treasureDurability<=0:
			$"../Sprite2D".global_position=position
			$"../Sprite2D".visible=true
			var tween = get_tree().create_tween()
			tween.set_pause_mode(Tween.TweenPauseMode.TWEEN_PAUSE_PROCESS)
			
			tween.tween_property($"../Sprite2D", "scale", Vector2(60, 60), 3)
			get_parent().get_node("MainMusic").stream=preload("res://wizard/game_over_without_ticking.mp3")
			get_parent().get_node("MainMusic").process_mode = Node.PROCESS_MODE_ALWAYS
			tween.finished.connect(get_parent().get_node("MainMusic").play)
			$"../CanvasLayer/TimeControl/RestartUI/Clock".game_over=true
			for i in get_parent().get_node("CanvasLayer").get_children():
				for j in i.get_children():
					if j.name!="RestartUI":
						j.queue_free()
			SpellMixer.chosen_items=[null, null, null, null, null]
			
			body.queue_free()
			get_tree().paused = true
			restart_ui.visible = true
			
			tween.tween_property(restart_ui, "modulate", Color(1, 1, 1, 1), 2)
			tween.finished.connect(tween.kill)
			if player != null:
				player.process_mode = PROCESS_MODE_PAUSABLE
			tween.finished.connect(turn_on_restart)
			tween.finished.connect(queue_free)
			
func turn_on_restart():
	restart_ui.get_node("RestartButton").action="restart"
func the_end_of_forest():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color(0, 0, 0, 0), 1)
	tween.finished.connect(queue_free)		
	
