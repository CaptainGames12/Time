extends Static
func _init() -> void:
	await get_tree().create_timer(0.2).timeout
	if get_parent().is_class("Area2D"):
		get_parent().queue_free()
	spawn_area(main, spell.spawn_area, get_parent().position)
