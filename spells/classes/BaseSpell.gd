extends Node
class_name BaseSpell
var spell: InvItem

func apply_effect(body:Node2D):
	body.health -= spell.damage
	
