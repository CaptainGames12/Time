extends AnimatedSprite2D


func _on_audio_stream_player_2d_finished() -> void:
	get_tree().quit()
