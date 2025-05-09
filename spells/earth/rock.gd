extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(2).timeout
	queue_free()
	

@onready var rock_attack: AnimationPlayer = $RockAttack


func _on_body_entered(body: CharacterBody2D) -> void:
	
	if body.is_in_group("enemy"):
		body.health-=1
	if body.is_in_group("boss") and body.isAngried:
		
		body.boss_health-=1
	
