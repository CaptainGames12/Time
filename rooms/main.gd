extends Node2D

func _process(delta):
	pass


func _on_scene_changer_body_entered(body):
	if body==$Player:
		get_tree().change_scene_to_file("res://rooms/shop.tscn")
