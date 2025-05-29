extends Sprite2D
@onready var silhouette: Sprite2D = $"../../Silhouette"

func _ready() -> void:
	silhouette.global_position=global_position
	silhouette.texture = texture
	silhouette.hframes = hframes
	silhouette.vframes = vframes
	silhouette.offset = offset
	silhouette.flip_h = flip_h
	silhouette.frame = frame
	silhouette.scale = scale
func _set(property: StringName, value: Variant) -> bool:
	match property:
			"texture":
				silhouette.texture = value
			"hframes":	
				silhouette.hframes = value
			"vframes":	
				silhouette.vframes = value
			"offset":	
				silhouette.offset = value
			"flip_h":
				silhouette.flip_h = value
			"frame":	
				silhouette.frame = value
	return false
