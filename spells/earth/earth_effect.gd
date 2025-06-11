extends Static
var ticks = 10
var attack_node 
func _init() -> void:
	spell_node=preload("res://spells/earth/rock.tscn")
	
	
func _physics_process(delta: float) -> void:
	attack_node = get_parent()
	print("attack_node:"+str(attack_node.global_position))
	if ticks==10:
		spawn_area(get_tree().root.get_node("Node2D"), spell_node, attack_node.global_position)
		ticks=0
		pass
	ticks+=1
