extends Node

const time_stop = "Awesome. You have ability to control time with golden clocks, which I gave you. Try pressing [img]res://ui/time_stop_button.png[/img] to stop time."
const time_reverse = "Goog. Now press [img]res://ui/save_button.png[/img] to [wave]save[/wave] your time point and turn back in time if something bad happens. Remember it needs your whole mana."
const greetings = "Hello. My time has come. So it is your turn to defend [rainbow][wave]the Crystal of harmony[/wave][/rainbow]. I hope I teached you well." 
const question = "Do you need jogging your memory?


[url=positive_answer]If you could, please[/url]		[url=negative_answer]I think I'm ready[/url]"
const shop = "So firstly, you need to buy spells in the shop. You have got 10 coins which you can spend anylike you want."
const shoped = "Wonderful. Now come back to the main level, then I shall remember you how to cast spells."
const shooting = "Choose spell in inventory by touching. After that, aim your joystick to cast spell in this direction. Every spell has its own effect."
const ending = "Well done. Future of our world is in your hands. Good luck."
const skipping = "Then good luck. Future of our world is in your hands."
var timeline = {
	1:greetings,
	2:question,
	3:shop,
	4:shoped,
	5:shooting,
	6:ending,
	7:skipping,
	8:time_stop,
	9:time_reverse
}
var place = 1
