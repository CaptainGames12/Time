extends TextureButton
signal show_ad
@onready var main:Node2D= get_node("/root/Node2D")
func _ready() -> void:
	show_ad.connect(main.main_show_ad)

func _on_pressed() -> void:
	show_ad.emit()
