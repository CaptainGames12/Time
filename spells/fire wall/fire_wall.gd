extends CPUParticles2D
var spell_manager = preload("res://spell_manager.tscn")
var fire = preload("res://spells/fire/fire.tres")
var fire_dmg: int
@export var fire_effect:GDScript
func _ready() -> void:
	await get_tree().create_timer(4).timeout
	queue_free()
func _on_area_2d_body_entered(body: Node2D) -> void:
		body.add_child(spell_manager.instantiate())
		body.get_node("SpellManager").set_script(fire_effect)
		fire_dmg = SpellMixer.spell.damage
		body.get_node("SpellManager").spell = fire
		body.get_node("SpellManager").spell.damage = fire_dmg
		body.get_node("SpellManager").apply_effect(body)


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.name=="Attack":
		if area.has_method("spell"):
			if area.spell.item_name=="water" or area.spell.item_name=="ice":
				queue_free()
