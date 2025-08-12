extends Static
var tick = 0
func random_vector():
	return Vector2(randi_range(-1, 1), randi_range(-1, 1))
	
func _physics_process(_delta: float) -> void:
	
	if tick >= 30:
		get_parent().final_direction = random_vector()
		tick = 0
		
	tick+=1
