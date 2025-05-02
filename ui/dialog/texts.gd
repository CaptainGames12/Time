extends Node

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
	7:skipping
}
var place = 1
