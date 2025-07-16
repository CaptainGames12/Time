extends Bullet
func apply_effect(body):
	super.apply_effect(body)
	body.SPEED=20
	body.get_node("AnimationPlayer").speed_scale=0.5
	body.call_deferred("add_child", spell.particle.instantiate())
	await get_tree().create_timer(2).timeout
	body.get_node("AnimationPlayer").speed_scale=1
	body.SPEED=100
	queue_free()
