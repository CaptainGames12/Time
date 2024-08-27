class_name Scene_Manager extends Node
@onready var player: Player 
var scene_dir_path = "res://rooms/"
var last_scene : String
func change_scene(from, to: String)->void:
	last_scene = from.name
	player = from.get_node("Player")
	player.get_parent().remove_child(player)
	var full_path = scene_dir_path+to+".tscn"
	from.get_tree().call_deferred("change_scene_to_file", full_path)
