extends StaticBody2D

func _ready() -> void:
	rotation = randi_range(0, PI)
	await get_tree().create_timer(0.3).timeout
	$CollisionShape2D2.disabled=false
	await get_tree().create_timer(4).timeout
	queue_free()
