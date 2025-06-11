extends Control
var save_path = "user://save.tres"
@onready var loaded_map: TextureRect = $LoadedMap
@onready var timeful_adventure: Label = $"Timeful adventure"
@onready var new: TouchScreenButton = $New
@onready var load: TouchScreenButton = $Load
@onready var settings: TextureRect = $SettingsBack
@onready var settings_btn: TouchScreenButton = $Settings
@onready var level_buttons: Control = $LevelButtons
var main_menu_text = preload("res://Localization/main_menu_text.tres")
func _on_new_pressed() -> void:
	open_map()
	
	if save_path !=null:
		DirAccess.remove_absolute(save_path)

func _on_load_pressed() -> void:
	open_map()
func change_scene(location):
	get_tree().change_scene_to_file("res://rooms/"+location+"/"+location+".tscn")

func open_map():
	var tween = get_tree().create_tween().set_parallel()
	tween.tween_property(loaded_map, "modulate", Color(1, 1, 1, 1), 2)
	tween.tween_property(new, "modulate", Color(1, 1, 1, 0), 2)
	tween.tween_property(load, "modulate", Color(1, 1, 1, 0), 2)
	tween.tween_property(timeful_adventure, "modulate", Color(1, 1, 1, 0), 2)
	tween.tween_property(settings_btn, "modulate", Color(1, 1, 1, 0), 2)
	tween.chain()
	tween.tween_property(level_buttons, "modulate", Color(1, 1, 1, 1), 2)
	tween.finished.connect(show_location_buttons)
func show_location_buttons():
	level_buttons.visible=true
	for i in level_buttons.get_children():
		i.disabled=false
func _on_settings_pressed() -> void:
	settings.visible=true

func _on_ukrainian_toggled(toggled_on: bool) -> void:
	TranslationServer.set_locale("uk")
	Texts.translated.emit()
	new.get_child(0).text=tr("new")
	settings_btn.get_child(0).text=tr("settings")
	load.get_child(0).text=tr("continue")
	
func _on_english_toggled(toggled_on: bool) -> void:
	TranslationServer.set_locale("en")
	Texts.translated.emit()
	new.get_child(0).text=tr("new")
	settings_btn.get_child(0).text=tr("settings")
	load.get_child(0).text=tr("continue")
	

func _on_main_level_choosen(btn: Variant) -> void:
	change_scene(btn.name)
