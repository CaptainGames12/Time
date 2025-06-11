extends Node
signal translated
func _ready() -> void:
	translated.connect(translate)
var time_stop = "time_stop"
var time_reverse = "time_reverse"
var greetings = "greetings"
var question = "question"
var shop = "shop"
var shoped = "shoped"
var shooting = "shooting"
var ending = "ending"
var skipping = "skipping"
var congrats = "congrats"
var mix = "mix"

var timeline = {
	1:greetings,
	2:question,
	3:shop,
	4:shoped,
	5:shooting,
	6:ending,
	7:skipping,
	8:time_stop,
	9:time_reverse,
	10:congrats,
	11:mix
}
var place = 1
var clockphrase1 = "clockphrase1"
var clockphrase2 = "clockphrase2"
var clockphrase3 = "clockphrase3"
var clockphrases={
	1:clockphrase1,
	2:clockphrase2,
	3:clockphrase3
}
func translate():
	for i in timeline.keys():
		tr(timeline[i])
	for i in clockphrases.keys():
		tr(clockphrases[i])
	
