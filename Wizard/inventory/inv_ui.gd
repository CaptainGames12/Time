extends Control
class_name Inventory

@export var itemsList = preload("res://Wizard/inventory/playerinv.tres")
@onready var slotsUi = get_children()
@onready var mixing = get_parent().get_node("Mixing")
func _ready() -> void:
	
	itemsList.update.connect(update_slots)
	update_slots()
	print("inv updated")
	
func update_slots():
	if slotsUi!=null:
		for i in range(min(itemsList.slots.size(), slotsUi.size())):
			slotsUi[i].update(itemsList.slots[i])
			slotsUi[i].element=itemsList.slots[i].item
		

func choose_element(element):
	
	print(SpellMixer.chosen_items.size())
	for i in range(0, SpellMixer.chosen_items.size()):
		if SpellMixer.chosen_items[i]==null:
			SpellMixer.chosen_items[i]=element
			break
	print(SpellMixer.chosen_items)
	mixing.update_mixer()
func _on_slot_3_pressed() -> void:
	choose_element(%Slot3.element)
	
func _on_slot_2_pressed() -> void:
	choose_element(%Slot2.element)


func _on_slot_1_pressed() -> void:
	choose_element(%Slot1.element)
