extends TextureRect
@onready var slots=$GridContainer.get_children()
func update_mixer():
	for i in slots.size():
		if SpellMixer.chosen_items[i]!=null:
			slots[i].texture_normal=SpellMixer.chosen_items[i].small_texture

func _ready() -> void:
	for i in slots:
		i.btn_down.connect(remove_element)
		
func remove_element(obj):
	obj.texture_normal=null
	SpellMixer.chosen_items[obj.button_id]=null
	print(SpellMixer.chosen_items)
	
