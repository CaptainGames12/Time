class_name Base_Scene extends Node

@onready var player: Player = get_node("Player")
@onready var entrance: Node2D = $Entrances
func _ready():
	if SceneManager.player:
		if player:
			player.queue_free()
		player = SceneManager.player
		add_child(player)
	position_player()
func position_player():
	var last_scene = SceneManager.last_scene
	if last_scene.is_empty():
		last_scene = "any"
	for entries in entrance.get_children():
		if entries is Marker2D and entries.name == "any" or last_scene == "any":
			player.global_position = entries.global_position

