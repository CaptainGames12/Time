extends BaseSpell
## Static class is used for creating static spells which are just staying on floor mostly
class_name Static
var main = get_parent().get_parent()
var spell_node: PackedScene
## Spawns spell entity on the floor on the position of attack area, which is shoot by Player
func spawn_area(scene: Node2D, area: PackedScene, pos: Vector2)->void:
	if area!=null:	
		var area_node = area.instantiate()
		area_node.global_position=pos
		scene.add_child(area_node)
		print(pos)
