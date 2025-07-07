extends Bullet
var attack_direction: Vector2
var knock_speed: int = 200
var attack_entity: Area2D
func _init() -> void:
	attack_entity = get_parent()
func _physics_process(delta: float) -> void:
	if attack_entity!=null:	
		attack_direction = attack_entity.target_fire
	
func apply_effect(body):
	super.apply_effect(body)
	body.velocity+=attack_direction*knock_speed	
	body.move_and_collide(body.velocity)
