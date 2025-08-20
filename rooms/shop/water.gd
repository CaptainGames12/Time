extends Area2D
@onready var water_hole = preload("res://sink.tscn")

func _on_body_entered(body: CharacterBody2D) -> void:
	body.get_node("WizardSprites").size=Vector2(107, 110)
	body.global_position.y+=10



func _on_body_exited(body: Node2D) -> void:
	if body.get_node("WizardSprites")!=null:
		body.get_node("WizardSprites").size=Vector2(107, 163)
		body.global_position.y-=10
