extends Static
var ticks = 5

func _physics_process(_delta: float) -> void:
	
	if spell.spawn_area!=null:
		if ticks==5:
			spawn_area(get_tree().root.get_node("Node2D"), spell.spawn_area, get_parent().global_position)
			ticks=0
			
		ticks+=1
