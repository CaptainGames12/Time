extends TextureRect
@onready var language: Control = $Language


func _on_language_pressed() -> void:
	get_node("Settings").visible=false
	language.visible=true


func _on_close_pressed() -> void:
	
	for i in get_children():
		if i.get_class()=="Control" and i.visible:
			print(i.get_class())
			i.visible=false
			if !$Settings.visible:
				$Settings.visible=true
		if i.get_class()=="GridContainer" and i.visible:
			print(i.get_class())
			visible=false
