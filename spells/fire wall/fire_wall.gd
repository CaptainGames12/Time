extends CPUParticles2D
@export var fire_wall:InvItem
func _ready() -> void:
	await get_tree().create_timer(4).timeout
	queue_free()
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		body.fired()
		


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.name=="Attack":
		if area.has_method("spell"):
			if area.spell.item_name=="water" or area.spell.item_name=="ice":
				queue_free()
