extends AnimatedSprite2D

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		SignalBus.coin_collected.emit(1)
		Global.score+=1
		
		body.collect_coin.play()
		queue_free()
