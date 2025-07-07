extends Node
## Mixer is used for mixing chosen elements
class_name Mixer
var chosen_items= [null, null, null, null, null]

var elements={
	"fire":preload("res://spells/fire/fire.tres"),
	"earth":preload("res://spells/earth/earth.tres"),
	"wind":preload("res://spells/wind/wind.tres"),
	"ice":preload("res://spells/ice/ice.tres"),
	"fire+ice":preload("res://spells/water/water.tres"),
	"fire+wind":preload("res://spells/smoke/smoke.tres"),
	"earth+fire":preload("res://spells/fire wall/fire_wall.tres"),
	"ice+wind":preload("res://spells/blizzard/blizzard.tres"),
	"earth+ice":preload("res://spells/wall/wall.tres"),
	"earth+wind":preload("res://spells/rift/rift.tres")
	}
var spell: InvItem
## This method mixes chosen elements and sums damage of same elements in collection
func mix(arr:Array[String]):
	var dmg = 0
	var same_elements:Dictionary[String, int]={
		"fire":0,
		"wind":0,
		"ice":0,
		"earth":0
	}
	for i in chosen_items:
		if i!=null:
			if same_elements.has(i.item_name):	
				same_elements[i.item_name]+=1
	var combo:String=""
	arr.sort()
	var unique = []

	for item in arr:
		if not unique.has(item):
			unique.append(item)
	combo = "+".join(unique.filter(func(x):return x!=null))
		
	var spell
	var new_damage=0
	if elements.has(combo):	
		spell=elements[combo].duplicate()
		
		for i in same_elements.keys():
			
			if same_elements[i]>0:
				
				spell.damage+=elements[i].damage*same_elements[i]
	
	return spell
	
