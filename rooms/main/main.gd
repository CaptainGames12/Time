extends Base_Scene
@onready var level_progress: TextureProgressBar = $Player/CanvasLayer/LevelProgress

@onready var restart_ui = $Player/CanvasLayer/RestartUI/RestartButton
@onready var inv = %Control
var save_path = "user://save.tres"
@onready var texture_rect: TextureRect = $TextureRect
@onready var current_level = 1
@onready var saver = ResourceSaver
@onready var loader = ResourceLoader.load(save_path) as SaveGame
var saving = SaveGame.new()
@onready var boss_clock = preload("res://Enemies/boss/evil_clock_boss.tscn")
@onready var entrance_shop: StaticBody2D = $Entrance_shop
@onready var dialogs: Control = $Player/CanvasLayer/Dialogs
var rewarded_ad : RewardedAd
var rewarded_ad_load_callback := RewardedAdLoadCallback.new()
var on_user_earned_reward_listener := OnUserEarnedRewardListener.new()

func _ready():
	
	MobileAds.initialize()
	
	rewarded_ad_load_callback.on_ad_failed_to_load = on_rewarded_ad_failed_to_load
	rewarded_ad_load_callback.on_ad_loaded = on_rewarded_ad_loaded
	
	on_user_earned_reward_listener.on_user_earned_reward = func(rewarded_item : RewardedItem):
		Global.hp=10
		player.healthbar.value=10
	Texts.place =1
	open_shop()
	scene_changer.monitoring = true
	if dialogs.is_inside_tree():
		close_shop()
	DialogSignals.go_to_the_shop.connect(open_shop)
	DialogSignals.tutorial_finished.connect(open_shop)
	get_tree().paused=true
	if loader != null:	
		DialogSignals.tutorial_finished.emit()
		$Player/CanvasLayer/Dialogs.queue_free()
		player.global_position = loader.player_pos
		player.healthbar.value = loader.player_health
		player.score = loader.player_score
		current_level = loader.level
		Global.collected_items = loader.collected_items
		Global.score = loader.global_score 
		Global.hp = loader.global_hp
		inv.itemsList.slots = loader.player_inv
		inv.update_slots()
	else:
		printerr("isn't loaded")
	
	$CooldownBetweenWaves.autostart =true
	if SceneManager.player:
		$Player.global_position = $Entrances/any.global_position
@onready var inv_res = player.inv_res
@onready var boss_healthbar: Control = $Player/CanvasLayer/Boss_health
@onready var main_music: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var entrance_anim: AnimatedSprite2D = $Entrance_shop/Entrance_anim
@onready var scene_changer: Area2D = $Entrance_shop/SceneChanger

@onready var enemy_count: Dictionary[int, int] = {
	1:2,
	2:4,
	3:6,
	4:8,
	5:1
}
@onready var enemy = preload("res://Enemies/enemy.tscn")
@onready var rand = RandomNumberGenerator.new()
@onready var dead_enemies = 0
@onready var cooldowntimer = $CooldownBetweenWaves
@onready var spawnholder = $SpawnHolder
@onready var treasure = $Treasure
@onready var boss_clock_node = boss_clock.instantiate()
func _process(delta: float) -> void:
	if $Player/CanvasLayer/Heal_window.is_visible_in_tree():
		Engine.time_scale=0
	else:
		Engine.time_scale=1
	if boss_clock_node!= null:
		boss_healthbar.get_child(0).value= boss_clock_node.boss_health
func enemy_death():
	dead_enemies += 1
	
	if dead_enemies==enemy_count[current_level]:
		open_shop()
		current_level+=1
		cooldowntimer.start()
		print()
		dead_enemies=0
func spawn_enemies():
	
	if current_level<=4:
		for i in range(enemy_count[current_level]):
			var enemy_node = enemy.instantiate()
			var spawn_amount = spawnholder.get_child_count()-1
			var rand_num = rand.randi_range(0, spawn_amount)
			var spawn_pos = spawnholder.get_child(rand_num).position
			enemy_node.position=spawn_pos
			enemy_node.treasure = treasure
			add_child(enemy_node)
			await get_tree().create_timer(1, false).timeout
	elif current_level==5:
		main_music.stream = load("res://Enemies/boss/test1.mp3")
	
		main_music.play()
		
		add_child(boss_clock_node)
		boss_clock_node.hit_player.connect(player.boss_hit)
		boss_healthbar.get_child(0).value= boss_clock_node.boss_health
		boss_healthbar.get_child(0).max_value= boss_clock_node.boss_health
		boss_healthbar.visible = true
		
func update_level(level):
	
	if level_progress!=null:
		level_progress.value = current_level
	
	spawn_enemies()
func _on_cooldown_between_waves_timeout() -> void:
	close_shop()
	update_level(current_level)
		
func open_shop():
	print("shop is opened")
	PhysicsServer2D.set_active(true)
	
	scene_changer.monitoring = true
	entrance_anim.play("open")
	$Entrance_shop/Closed/ClosedCollision.disabled =true
func close_shop():
	print("shop is closed")
	scene_changer.monitoring = false
	entrance_anim.play("close")
	$Entrance_shop/Closed/ClosedCollision.disabled =false
	PhysicsServer2D.set_active(true)
func _on_restart_button_pressed() -> void:
	Texts.place=1
	get_tree().paused = false
	
	get_tree().reload_current_scene()
	restart_ui.visible = false
	

func _on_save_button_pressed() -> void:
	if player.stamina.value==100:
		player.stamina.value = 0
		player.timer.start()
		
		saving.collected_items = Global.collected_items
		saving.player_pos = player.global_position
		saving.player_health = player.healthbar.value
		saving.player_score = player.score
		saving.global_score = Global.score
		saving.global_hp = Global.hp
		saving.level = current_level
		saving.player_inv = inv.itemsList.slots
		
		saver.save(saving, save_path)
func the_end():
	$Main_animations.play("ending")

func _on_ending_animation_finished(anim_name: StringName="ending") -> void:
	get_tree().change_scene_to_file("res://rooms/ending/clapping.tscn")


func _on_button_pressed() -> void:
	if dialogs == null:
		$Player/CanvasLayer/Heal_window.visible = !$Player/CanvasLayer/Heal_window.visible 
		var unit_id : String
		if OS.get_name() == "Android":
			unit_id = "ca-app-pub-3940256099942544/5224354917"
		elif OS.get_name() == "iOS":
			unit_id = "ca-app-pub-3940256099942544/1712485313"

		RewardedAdLoader.new().load(unit_id, AdRequest.new(), rewarded_ad_load_callback)
		
func main_show_ad():
	if rewarded_ad:
		rewarded_ad.show(on_user_earned_reward_listener)
		print("is shown")
		
func on_rewarded_ad_failed_to_load(adError : LoadAdError) -> void:
	print(adError.message)
	
func on_rewarded_ad_loaded(rewarded_ad : RewardedAd) -> void:
	self.rewarded_ad = rewarded_ad
