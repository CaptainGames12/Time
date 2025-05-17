extends Sprite2D

@onready var money= get_parent().get_parent().get_node("CanvasLayer/MoneyUI/Money")


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		money.addMoney(1)
		Global.score+=1
		
		body.collect_coin.play()
		queue_free()
