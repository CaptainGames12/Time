extends TextureButton


func update(slot: InvSlot)->void:
	var display = get_child(0)
	if !slot.item:
		display.visible = false
	else:
		
		display.texture = slot.item.texture
		display.position = position
		display.visible = true
	print("changing sprite")
