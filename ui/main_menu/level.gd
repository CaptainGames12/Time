extends TextureButton
signal level_choosen(btn)

func _ready() -> void:
	for i in Global.open_levels:
		if i==get_node("Label").text:
			visible=true
func _on_pressed() -> void:
	level_choosen.emit(self)
