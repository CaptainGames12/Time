extends TextureRect
@onready var slots=$GridContainer.get_children()
func update_mixer():
	for i in slots.size():
		if SpellMixer.chosen_items[i]!=null:
			slots[i].icon=SpellMixer.chosen_items[i].texture
