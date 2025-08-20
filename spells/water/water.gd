extends Bullet
var first_speed
func apply_effect(body):
	super.apply_effect(body)
	first_speed = body.speed
	body.SPEED=first_speed/2

	body.call_deferred("add_child", spell.particle.instantiate())
	await get_tree().create_timer(2).timeout
	
	body.SPEED=first_speed
	queue_free()
