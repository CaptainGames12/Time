extends Area2D
@onready var water_hole = preload("res://sink.tscn")

func _on_body_entered(body: CharacterBody2D) -> void:
	var water_hole_node= water_hole.instantiate()
	body.add_child(water_hole_node)
	water_hole_node.position = Vector2(0, 28)


func _on_body_exited(body: Node2D) -> void:
	if body.get_node("Sink")!=null:
		body.get_node("Sink").queue_free()
