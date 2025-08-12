@tool
extends Control
@export var signal_name: String
@export var bar: TextureProgressBar
@export var temp_bar: TextureProgressBar
@export var timer: Timer
@export var bar_texture_progress: Texture2D
@export var temp_texture_progress: Texture2D
@export var icon: Texture2D
@export var icon_display: TextureRect
func _ready() -> void:
	
	SignalBus.connect(signal_name, change_value)
	icon_display.texture = icon
	bar.texture_progress = bar_texture_progress
	temp_bar.texture_progress = temp_texture_progress
func change_value(diff: float, type_of_value: String)->void:
	
	var rate_of_change_temp_bar: float = -1
	var rate_of_change_bar: float = 0.1
	if diff<0:
		update_bars(diff, bar, temp_bar, diff, rate_of_change_temp_bar)
	if diff>0:
		update_bars(diff, temp_bar, bar, diff*10, rate_of_change_bar)
	if type_of_value == "health":
		change_health(diff)

func update_bars(diff_for_updates:float, first_bar:TextureProgressBar, after_bar: TextureProgressBar, diff_for_instant_val_change: float, rate_of_change: float):
	var amount_of_updates: float = abs(diff_for_updates)*10
	timer.wait_time /= abs(diff_for_updates)
	first_bar.value += diff_for_instant_val_change
	for i in range(amount_of_updates):
		timer.start()
		after_bar.value += rate_of_change
		await timer.timeout
func change_health(diff: float):
	if diff!=0:
		Global.hp+=diff
	else:
		self.bar.value = Global.hp
		self.temp_bar.value = Global.hp
	if Global.hp <= 0:
		SignalBus.game_over.emit()
