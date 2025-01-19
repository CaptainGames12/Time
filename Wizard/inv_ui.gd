extends Control
class_name Inventory
@export var itemsList = preload("res://Wizard/playerinv.tres")
@onready var slotsUi = $GridContainer.get_children()

func _ready() -> void:
	itemsList.update.connect(update_slots)
	update_slots()
func update_slots():
	for i in range(min(itemsList.slots.size(), slotsUi.size())):
		slotsUi[i].update(itemsList.slots[i])
var chosen_item

func _on_texture_button_toggled(toggled_on: bool) -> void:
	chosen_item=itemsList.slots[0].item

func _on_texture_button_2_toggled(toggled_on: bool) -> void:
	chosen_item=itemsList.slots[1].item

func _on_texture_button_3_toggled(toggled_on: bool) -> void:
	chosen_item=itemsList.slots[2].item
	
func _on_texture_button_4_toggled(toggled_on: bool) -> void:
	chosen_item=itemsList.slots[3].item
