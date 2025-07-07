extends Node
##	Class for base spell is used to create effects for static and bullet spells.
##	Also it holds spell resource in itself.
class_name BaseSpell
##	This stores result of mixing elements in SpellMixer.
var spell: InvItem

## Base method of applying effect which can be modified in any script with spell effect.
func apply_effect(body:Node2D):
	body.health -= spell.damage
	
