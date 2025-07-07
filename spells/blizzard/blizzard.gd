extends CPUParticles2D
var enemy = null
var dmg = SpellMixer.spell.damage
func _ready() -> void:
	await get_tree().create_timer(3).timeout
	queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		body.SPEED=0
		body.health-=dmg
	if body.is_in_group("boss"):
		if !body.is_protected:
			body.SPEED=0
			body.health-=dmg

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		body.SPEED=100
		
	if body.is_in_group("boss"):
		body.SPEED=20
		
