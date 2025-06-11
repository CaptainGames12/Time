extends BaseSpell
class_name Static
var main = get_parent().get_parent()
var spell_node: PackedScene
func spawn_area(scene: Node2D, area: PackedScene, pos: Vector2)->void:
	var area_node = area.instantiate()
	area_node.global_position=pos
	scene.add_child(area_node)
	print(pos)
