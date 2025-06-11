extends Area2D

func _ready() -> void:
	get_parent().move_child(self, 0)
	y_sort_enabled=false
	await get_tree().create_timer(3).timeout
	await dmg_enemy
	queue_free()
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		body.get_node("Attack/CollisionShape2D").disabled=true
		body.get_node("CollisionShape2D").disabled=true
		body.position=global_position
		var tween = get_tree().create_tween().parallel()
		body.SPEED=0
		
		#tween.tween_property(body, "scale", Vector2.ZERO, 1)
		tween.tween_property(body, "position", Vector2(body.position.x, body.position.y+40), 0.5)
		tween.tween_property(body, "modulate", Color(0, 0, 0, 0), 1)
		
		#tween.tween_property(body, "rotation_degrees", 360, 3).as_relative().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
		
		tween.finished.connect(dmg_enemy.bind(body))
		
func dmg_enemy(body):
	if body!=null:	
		body.health-=10
		body.get_node("Attack/CollisionShape2D").disabled=false
		body.get_node("CollisionShape2D").disabled=false
		
		var tween = get_tree().create_tween()
		body.SPEED=100
		
		tween.tween_property(body, "modulate", Color(1, 1, 1, 1), 0.5)
