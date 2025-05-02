extends Sprite2D
@export var item:InvItem
@onready var shop: Node2D = $"../.."


var player = null

func _on_collectable_body_entered(body: Node2D) -> void:
	
	player = body
	if Global.score >= item.price:
		Global.collected_items.append(item.item_name)
		Global.score -= item.price
		player.score = Global.score
		player.collect(item)
		DialogSignals.emit_signal("bought")
		get_parent().queue_free()
