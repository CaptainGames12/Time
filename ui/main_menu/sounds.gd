extends Control


func _on_sfx_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(value))
	
func _on_music_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(value))
	print(linear_to_db(value))

func _on_sfx_slider_drag_ended(value_changed: bool) -> void:
	$SFX/AudioStreamPlayer.play()
