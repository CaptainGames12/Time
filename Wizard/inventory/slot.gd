extends TouchScreenButton
@export var element:Resource
@export var display: Sprite2D
func update(slot: InvSlot)->void:
	
	print(display.name)
	if slot.item:
	
		display.texture = slot.item.texture
		display.position = Vector2(0, 0)
		display.visible = true
		print("changing sprite")
