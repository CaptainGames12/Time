extends AnimatedSprite2D


func _on_audio_stream_player_2d_finished() -> void:
	get_tree().change_scene_to_file("res://ui/main_menu/main_menu.tscn")
