extends Bullet
func apply_effect(body):
	var freeze_mat = preload("res://spells/ice/freeze.tres").duplicate() as ShaderMaterial
	super.apply_effect(body)
	body.get_node("Animation").material = freeze_mat
	freeze_mat.set_shader_parameter("freeze_amount", 1)
	body.get_node("Attack").monitoring =false
	body.SPEED = 0
	if body.is_in_group("enemy"):
		await get_tree().create_timer(4).timeout
		body.attack_animation_player.play()
	if body.is_in_group("boss"):
		await get_tree().create_timer(2).timeout
	if !is_instance_valid(body):
		return
	body.get_node("Attack").monitoring =true
	freeze_mat.set_shader_parameter("freeze_amount", 0)
	body.SPEED = 100	
		
