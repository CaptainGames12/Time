extends Control
var save_path = "user://save.tres"

func _on_new_pressed() -> void:
	change_scene()
	if save_path !=null:
		DirAccess.remove_absolute(save_path)

func _on_load_pressed() -> void:
	change_scene()
func change_scene():
	get_tree().change_scene_to_file("res://rooms/main/main.tscn")


func _on_english_pressed() -> void:
	TranslationServer.set_locale("en")
	for i in Texts.timeline.keys():
		tr(Texts.timeline[i])
		

func _on_ukrainian_pressed() -> void:
	TranslationServer.set_locale("uk")
	for i in Texts.timeline.keys():
		tr(Texts.timeline[i])
