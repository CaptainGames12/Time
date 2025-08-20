
extends Control
class_name Bar

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
	temp_bar.global_position = bar.global_position
func change_value(diff: float, additional_value: Variant)->void:
	if additional_value is Boss: 
		change_boss_health(diff, additional_value)	
	if additional_value is CharacterBody2D and additional_value is not Boss:
		change_enemy_health(diff, additional_value)
		if additional_value != owner:
			return
	
	var rate_of_change_temp_bar: float = -1
	var rate_of_change_bar: float = 0.1
	if diff<0:
		update_bars(diff, bar, temp_bar, diff, rate_of_change_temp_bar)
	if diff>0:
		update_bars(diff, temp_bar, bar, diff*10, rate_of_change_bar)
	if str(additional_value) == "health":
		change_health(diff)
	
func change_enemy_health(diff: float, enemy: CharacterBody2D):
	enemy.health += diff
	if(enemy.health<=0):
		print("dead enemy")
		enemy.animation.stop()
		enemy.animation.play("death")
		enemy.animation.animation_finished.connect(enemy.spawn_coin_and_free)
func change_boss_health(diff: float, boss: CharacterBody2D):
	print("boss health changed")
	boss.health += diff	
	if(boss.health<=0):
		boss.get_node("Collision").disabled=true
		if boss.phrases!=null:	
			boss.phrases.queue_free()
		boss.get_parent().get_node("Treasure").the_end_of_forest()
		boss.get_parent().get_node("Interface").add_child(boss.master_dialog)
			
		boss.clock_boss_sprite.animation_finished.connect(boss.queue_free)
			
		boss.clock_boss_sprite.play("death")
					
	
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
