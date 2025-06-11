extends Static


# Called when the node enters the scene tree for the first time.
func _init() -> void:
	await get_tree().create_timer(0.2).timeout
	get_parent().queue_free()
	spawn_area(main, spell.particle, get_parent().position)
