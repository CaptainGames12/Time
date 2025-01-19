extends Sprite2D
@export var item:InvItem

var player = null

func _on_collectable_body_entered(body: Node2D) -> void:
	player = body
	if player.score >= item.price:
		player.score -= item.price
		player.collect(item)
		get_parent().queue_free()
