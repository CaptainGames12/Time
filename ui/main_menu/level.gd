extends TextureButton
signal level_choosen(btn)


func _on_pressed() -> void:
	level_choosen.emit(self)
