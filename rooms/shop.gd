extends Node2D


# Called when the node enters the scene tree for the first time.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_scene_changer_body_entered(body):
	if body==$Player:
		get_tree().change_scene_to_file("res://rooms/main.tscn")
