extends Node2D
var rewarded_ad_object : RewardedAd
var rewarded_ad_load_callback := RewardedAdLoadCallback.new()
var on_user_earned_reward_listener := OnUserEarnedRewardListener.new()
@onready var player = $Player
@onready var entrance_shop: StaticBody2D = $Entrance_shop
@export var dialogs: Control 

@onready var treasure = $Treasure


func ad_initialize():
	MobileAds.initialize()
	
	rewarded_ad_load_callback.on_ad_failed_to_load = on_rewarded_ad_failed_to_load
	rewarded_ad_load_callback.on_ad_loaded = on_rewarded_ad_loaded
	
	on_user_earned_reward_listener.on_user_earned_reward = func(_rewarded_item : RewardedItem):
		Global.hp=10
		player.healthbar.value=10

func _notification(what: int) -> void:
	
	if what==NOTIFICATION_WM_CLOSE_REQUEST:
		if "user://save.tres"!=null:
			DirAccess.remove_absolute("user://save.tres")

func _ready():
	DialogSignals.forest_end.connect($Main_animations.play.bind("ending"))
	Global.current_scene=self.scene_file_path

	ad_initialize()
	Texts.place =1
	DialogSignals.go_to_the_shop.connect($Entrance_shop.open_shop)
	DialogSignals.tutorial_finished.connect($Entrance_shop.open_shop)
	

func _on_ending_animation_finished(_anim_name: StringName="ending") -> void:
	get_tree().change_scene_to_file("res://rooms/ending/clapping.tscn")
	var there_is_level=false
	for i in Global.open_levels:
		if i=="town":
			there_is_level = true
	if !there_is_level:
		Global.open_levels.append("town")

func _on_button_pressed() -> void:
	if dialogs == null:
		%Heal_window.visible = !%Heal_window.visible 
		get_tree().paused=%Heal_window.visible
		match %Heal_window.visible:
			true:
				$CanvasLayer/TimeControl.process_mode=Node.PROCESS_MODE_PAUSABLE
				player.stamina_timer.stop()
				player.process_mode=Node.PROCESS_MODE_PAUSABLE
			false:
				$CanvasLayer/TimeControl.process_mode=Node.PROCESS_MODE_ALWAYS
				player.stamina_timer.start()
				player.process_mode=Node.PROCESS_MODE_ALWAYS
				
		var unit_id : String
		if OS.get_name() == "Android":
			unit_id = "ca-app-pub-3940256099942544/5224354917"
		elif OS.get_name() == "iOS":
			unit_id = "ca-app-pub-3940256099942544/1712485313"

		RewardedAdLoader.new().load(unit_id, AdRequest.new(), rewarded_ad_load_callback)
		
func main_show_ad():
	if rewarded_ad_object:
		rewarded_ad_object.show(on_user_earned_reward_listener)
		print("is shown")
		
func on_rewarded_ad_failed_to_load(adError : LoadAdError) -> void:
	print(adError.message)
	
func on_rewarded_ad_loaded(rewarded_ad : RewardedAd) -> void:
	self.rewarded_ad = rewarded_ad
