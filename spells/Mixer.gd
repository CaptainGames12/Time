extends Node
class_name Mixer
var elements={
	"fire":preload("res://spells/fire/fire.tres"),
	"earth":preload("res://spells/earth/earth.tres"),
	"wind":preload("res://spells/wind/wind.tres"),
	"ice":preload("res://spells/ice/ice.tres"),
	"fire+ice":preload("res://spells/water/water.tres"),
	"fire+wind":preload("res://spells/smoke/smoke.tres")
	}
func mix(arr:Array[String]):
	var combo:String=""
	arr.sort()
	combo = "+".join(arr.filter(func(x):return x!=null))
	
	var spell
	if elements.has(combo):	
		spell=elements[combo]
		
	return spell
