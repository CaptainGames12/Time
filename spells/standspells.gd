extends Sprite2D
@export var item:InvItem

var player = null

func _on_collectable_body_entered(body: Node2D) -> void:
	player = body
	if Global.score >= item.price:
		Global.score -= item.price
		player.score = Global.score
		player.collect(item)
		get_parent().queue_free()
