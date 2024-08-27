extends Node2D

func _ready():
	if SceneManager.player:
		add_child(SceneManager.player)
		SceneManager.player.global_position = $Entrances/any.global_position
