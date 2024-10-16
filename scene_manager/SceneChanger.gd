extends Area2D

@export var scene : String

func _on_body_entered(body):
	SceneManager.change_scene(get_owner(), scene)
