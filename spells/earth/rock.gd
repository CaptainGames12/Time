extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(2).timeout
	queue_free()
	

@onready var rock_attack: AnimationPlayer = $RockAttack


func _on_body_entered(body: CharacterBody2D) -> void:
	
	if body.is_in_group("enemy"):
		body.health-=1
		print("enemy health: "+ str(body.health))
	if body.is_in_group("boss"):
		body.boss_health-=1
	
