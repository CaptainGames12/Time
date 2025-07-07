extends Static
var target_pos:Vector2
func _ready() -> void:
	await dmg_enemy
	queue_free()
func apply_effect(body) -> void:
	super.apply_effect(body)
	if body.is_in_group("enemy"):
		body.get_node("Attack/CollisionShape2D").set_deferred("disabled", true)
		body.get_node("CollisionShape2D").set_deferred("disabled", true)
		body.position=target_pos
		var tween = get_tree().create_tween().parallel()
		body.SPEED=0
		
		tween.tween_property(body, "position", Vector2(body.position.x, body.position.y+40), 0.5)
		tween.tween_property(body, "modulate", Color(0, 0, 0, 0), 1)

		tween.finished.connect(dmg_enemy.bind(body))
func dmg_enemy(body):
	if body!=null:	
		body.health-=spell.damage
		
		body.get_node("Attack/CollisionShape2D").disabled=false
		body.get_node("CollisionShape2D").disabled=false
		
		var tween = get_tree().create_tween()
		body.SPEED=100
		
		tween.tween_property(body, "modulate", Color(1, 1, 1, 1), 0.5)
