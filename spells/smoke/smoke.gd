extends Area2D
var smoke_effect = preload("res://spells/smoke/smoke_effect.gd")
var enemy : Array[CharacterBody2D]
var spell_manager = preload("res://spell_manager.tscn")
var smoke = preload("res://spells/smoke/smoke.tres")
var smoke_dmg: int

func _ready() -> void:
	await get_tree().create_timer(4).timeout
	remove_effect()
	print(" ENEMY : " + str(enemy))
	
	get_parent().queue_free()
	
func _on_body_entered(body: Node2D) -> void:
	print(" ENEMY ENTER : " + str(body))
	if body.is_in_group("enemy"):
		body.confused = true;
		SignalBus.enemy_health_changed.emit(-SpellMixer.spell.damage, body)
		enemy.append(body)	
		$"../AnimationPlayer".play("collide")

func remove_effect() -> void: 
	for body in enemy:
		if(body != null) :
			body.confused = false;
