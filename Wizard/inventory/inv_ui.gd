extends Control
class_name Inventory
@export var itemsList = preload("res://Wizard/inventory/playerinv.tres")
@onready var slotsUi = $GridContainer.get_children()

func _ready() -> void:
	for i in itemsList.slots:
		if i.item:
			print(i.item.item_name)
	itemsList.update.connect(update_slots)
	update_slots()
	print("inv updated")
	
func update_slots():

	for i in range(min(itemsList.slots.size(), slotsUi.size())):
		slotsUi[i].update(itemsList.slots[i])
	
var chosen_item={
	1:null,
	2:null,
	3:null,
	4:null
}
func _on_texture_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		if itemsList.slots[0].item!=null:
			chosen_item[1]=itemsList.slots[0].item.item_name
	if !toggled_on:
		chosen_item[1]=null
func _on_texture_button_2_toggled(toggled_on: bool) -> void:
	if toggled_on:
		if itemsList.slots[1].item!=null:
			chosen_item[2]=itemsList.slots[1].item.item_name
	if !toggled_on:
		chosen_item[2]=null
func _on_texture_button_3_toggled(toggled_on: bool) -> void:
	if toggled_on:
		if itemsList.slots[2].item!=null:
			chosen_item[3]=itemsList.slots[2].item.item_name
	if !toggled_on:
		chosen_item[3]=null
func _on_texture_button_4_toggled(toggled_on: bool) -> void:
	if toggled_on:
		if itemsList.slots[3].item!=null:
			chosen_item[4]=itemsList.slots[3].item.item_name
	if !toggled_on:
		chosen_item[4]=null
