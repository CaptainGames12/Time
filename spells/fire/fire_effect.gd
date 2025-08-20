extends Bullet

func apply_effect(body:Node2D):
	super.apply_effect(body)	
	body.call_deferred("add_child", spell.particle.instantiate())
	for i in range(4):
		await get_tree().create_timer(1).timeout
		super.apply_effect(body)
		if i==4:
			queue_free()
			
