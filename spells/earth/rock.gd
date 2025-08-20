extends Area2D

var spell = SpellMixer.spell

func _ready() -> void:
	
	$Rock.texture=SpellMixer.spell.texture
	await get_tree().create_timer(2).timeout
	queue_free()

@onready var rock_attack: AnimationPlayer = $RockAttack

func _on_body_entered(body: CharacterBody2D) -> void:
	
	if body.is_in_group("enemy"):
		SignalBus.enemy_health_changed.emit(-spell.damage, body)
		
	if body.is_in_group("boss") and !body.isProtected:
		SignalBus.enemy_health_changed.emit(-spell.damage, body)
		
	
