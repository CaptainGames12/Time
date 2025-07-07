extends Area2D
var spell_manager = preload("res://spell_manager.tscn")
var rift_effect = preload("res://spells/rift/rift_effect.gd")
var fall_dmg:int
var rift = load("res://spells/rift/rift.tres")
func _ready() -> void:
	get_parent().move_child(self, 0)
	y_sort_enabled=false
	await get_tree().create_timer(3).timeout
	queue_free()
func _on_body_entered(body: Node2D) -> void:
		if body.get_node_or_null("SpellManager")==null:	
			body.add_child(spell_manager.instantiate())
		body.get_node("SpellManager").set_script(rift_effect)
		fall_dmg = SpellMixer.spell.damage
		body.get_node("SpellManager").target_pos = global_position
		body.get_node("SpellManager").spell = rift
		body.get_node("SpellManager").spell.damage = fall_dmg
		body.get_node("SpellManager").apply_effect(body)
