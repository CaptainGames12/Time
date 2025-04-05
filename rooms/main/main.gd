extends Base_Scene
@onready var level_progress: TextureProgressBar = $Player/CanvasLayer/LevelProgress


@onready var restart_ui: Control = $Player/CanvasLayer/RestartUI/RestartButton
@onready var inv = %Control
var save_path = "user://save.tres"
@onready var texture_rect: TextureRect = $TextureRect
@onready var current_level = 1
@onready var saver = ResourceSaver
@onready var loader = ResourceLoader.load(save_path) as SaveGame
var saving = SaveGame.new()
@onready var boss_clock = preload("res://Enemies/boss/evil_clock_boss.tscn")
@onready var entrance_shop: StaticBody2D = $Entrance_shop

func _ready():
	entrance_anim.play("open")
	scene_changer.monitoring = true
	texture_rect.queue_free()
	
	if loader != null:	
		
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
	4:2,
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
		main_music.stream = load("res://Enemies/boss/bossclock.wav")
	
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
	scene_changer.monitoring = true
	entrance_anim.play("open")
	$Entrance_shop/Closed/ClosedCollision.disabled =true
func close_shop():
	scene_changer.monitoring = false
	entrance_anim.play("close")
	$Entrance_shop/Closed/ClosedCollision.disabled =false
func _on_restart_button_pressed() -> void:

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
	$Ending.play("ending")

func _on_ending_animation_finished(anim_name: StringName="ending") -> void:
	get_tree().change_scene_to_file("res://rooms/ending/clapping.tscn")
