extends GPUParticles2D
func _ready() -> void:
	for i in range(4):
		await get_tree().create_timer(1).timeout
		if i==4:
			queue_free()
