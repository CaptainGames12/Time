
extends Node2D


var is_restarted=false
var rewarded_ad : RewardedAd
var rewarded_ad_load_callback := RewardedAdLoadCallback.new()
var on_user_earned_reward_listener := OnUserEarnedRewardListener.new()
@onready var player = $Player
@onready var level_progress: TextureProgressBar = %LevelProgress


@onready var restart_ui: Control = %RestartUI
@onready var inv: Control = %InventoryUI

@onready var texture_rect: TextureRect = $TextureRect
@onready var current_level = 1

@onready var boss_clock = preload("res://enemies/forest/boss/evil_clock_boss.tscn")
@onready var entrance_shop: StaticBody2D = $Entrance_shop
@onready var dialogs: Control = %Dialogs

@onready var inv_res = player.inv_res
@onready var boss_healthbar: Control = %Boss_health
@onready var main_music: AudioStreamPlayer= %MainMusic
@onready var entrance_anim: AnimatedSprite2D = $Entrance_shop/Entrance_anim
@onready var scene_changer: Area2D = $Entrance_shop/SceneChanger

@onready var enemy_count: Dictionary[int, int] = {
	1:2,
	2:4,
	3:6,
	4:8,
	5:1
}

@onready var enemy = preload("res://enemies/forest/clock_enemy/enemy.tscn")
@onready var rand = RandomNumberGenerator.new()
@onready var dead_enemies = 0
@onready var cooldown_timer = $CooldownBetweenWaves
@onready var spawnholder = $SpawnHolder
@onready var treasure = $Treasure
@onready var boss_clock_node = boss_clock.instantiate()
@onready var stage_label_tween: Tween
signal in_the_shop
signal out_of_the_shop

func ad_initialize():
	MobileAds.initialize()
	
	rewarded_ad_load_callback.on_ad_failed_to_load = on_rewarded_ad_failed_to_load
	rewarded_ad_load_callback.on_ad_loaded = on_rewarded_ad_loaded
	
	on_user_earned_reward_listener.on_user_earned_reward = func(rewarded_item : RewardedItem):
		Global.hp=10
		player.healthbar.value=10

func _notification(what: int) -> void:
	
	if what==NOTIFICATION_WM_CLOSE_REQUEST:
		if "user://save.tres"!=null:
			DirAccess.remove_absolute("user://save.tres")

func _ready():
	DialogSignals.forest_end.connect($Main_animations.play.bind("ending"))
	Global.current_scene=self.scene_file_path
	if player.loader!=null:
		current_level=player.loader.level
		open_shop()
	else:
		get_tree().paused=true
		close_shop()
	%Money.addMoney(Global.score)
	ad_initialize()
	Texts.place =1
	DialogSignals.go_to_the_shop.connect(open_shop)
	DialogSignals.tutorial_finished.connect(open_shop)
	
	cooldown_timer.autostart =true
	in_the_shop.connect(pause_stage_tween)
	out_of_the_shop.connect(start_stage_tween)
func show_stage_completed():
	stage_label_tween = get_tree().create_tween().chain()
	stage_label_tween.tween_property(%StageCompleted, "visible_ratio", 1, 3)
	stage_label_tween.tween_interval(0.5)
	stage_label_tween.tween_property(%StageCompleted, "visible_ratio", 0, 3)
	stage_label_tween.finished.connect(stage_label_tween.kill)
func pause_stage_tween():
	if stage_label_tween!=null:
		stage_label_tween.pause()
		%StageCompleted.visible=false	
func start_stage_tween():
	if stage_label_tween!=null:
		stage_label_tween.play()
		%StageCompleted.visible=true	

func _process(delta: float) -> void:
	var enemies_are_here = []
	for i in get_children():
		if i.is_in_group("enemy"):
			enemies_are_here.append(i)
	if cooldown_timer.is_stopped() and enemies_are_here.is_empty() and boss_clock==null:
		show_stage_completed()
		open_shop()
		current_level+=1
		cooldown_timer.start()
		
		dead_enemies=0
	if boss_clock_node!= null:
		boss_healthbar.get_child(0).value= boss_clock_node.health
func enemy_death():
	dead_enemies += 1
	
	if dead_enemies==enemy_count[current_level]:
		show_stage_completed()
		start_stage_tween()
		open_shop()
		current_level+=1
		cooldown_timer.start()
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
		boss_healthbar.get_child(0).value= boss_clock_node.health
		boss_healthbar.get_child(0).max_value= boss_clock_node.health
		boss_healthbar.visible = true
		
func update_level():
	
	if level_progress!=null:
		level_progress.value = current_level
		level_progress.get_child(0).value=current_level-1
	spawn_enemies()
func _on_cooldown_between_waves_timeout() -> void:
	close_shop()
	update_level()
		
func open_shop():
	print("shop is opened")
	PhysicsServer2D.set_active(true)
	%OpenCloseAudio.play()
	scene_changer.monitoring = true
	entrance_anim.play("open")
	$Entrance_shop/Closed/ClosedCollision.disabled =true
func close_shop():
	print("shop is closed")
	PhysicsServer2D.set_active(true)	
	%OpenCloseAudio.play()
	scene_changer.monitoring = false
	entrance_anim.play("close")
	$Entrance_shop/Closed/ClosedCollision.disabled =false

func _on_restart_button_pressed() -> void:
	if Input.is_action_pressed("restart") and !is_restarted:
		is_restarted=true
		%MainMusic.stream=preload("res://wizard/fx_continue.mp3")
		
		%MainMusic.connect("finished", reset)
		%MainMusic.play()
	
func reset():
		Texts.place=1
		
		var tween = get_tree().create_tween()
		tween.set_pause_mode(2)
		
		print(tween.is_running())
		tween.tween_property($Sprite2D, "scale", Vector2(0, 0), 0.5)
		tween.tween_property(restart_ui, "modulate", Color(0, 0, 0, 0), 0.5)
		tween.finished.connect(get_tree().change_scene_to_file.bind("res://ui/loading.tscn"))
	

func _on_ending_animation_finished(anim_name: StringName="ending") -> void:
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
	if rewarded_ad:
		rewarded_ad.show(on_user_earned_reward_listener)
		print("is shown")
		
func on_rewarded_ad_failed_to_load(adError : LoadAdError) -> void:
	print(adError.message)
	
func on_rewarded_ad_loaded(rewarded_ad : RewardedAd) -> void:
	self.rewarded_ad = rewarded_ad
