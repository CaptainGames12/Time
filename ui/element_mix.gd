extends TextureButton
signal btn_down(obj)
@export var button_id:int

func _pressed() -> void:
	emit_signal("btn_down", self)
