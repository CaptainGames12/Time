extends Area2D

var dropped = false
@export var item: InvItem
@onready var shop: Node2D = get_parent()
@onready var money = get_parent().get_parent().get_node("CanvasLayer/MoneyUI/Money")
@onready var item_name: String = item.item_name
var player = null
func _ready() -> void:
	if get_node("Label")!=null:
		get_node("Label").text = str(item.price)+"$"

func _on_body_entered(body: Node2D) -> void:
	
	player = body
	var full = player.inv_res.slots.filter(func(x): return x.item==null)
	print(full)
	if Global.score >= item.price and !dropped and !full.is_empty():
		Global.collected_items.append(item.item_name)
		Global.score -= item.price
		money.removeCoins(item.price)
	
		player.collect(item)
		DialogSignals.emit_signal("bought")
		queue_free()
	elif dropped:
		player.collect(item)
		queue_free()
