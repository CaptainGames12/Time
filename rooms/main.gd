extends Base_Scene
@onready var treasure_label = $Treasure/Label
@onready var restart_ui: Control = $Player/CanvasLayer/RestartUI/RestartButton
@onready var inv = %Control
var save_path = "user://file.tres"
signal reload
func _ready():
	var saving = ResourceLoader.load(save_path, "", 2) as SaveGame
	if saving != null:	
		player.global_position = saving.player_pos
		player.healthbar.value = saving.player_health
		Global.score = saving.global_score 
		Global.hp = saving.global_hp
		player.score = saving.player_score
		Global.level = saving.level
		inv.itemsList.slots = saving.player_inv
	else:
		printerr("isn't loaded")
	$CooldownBetweenWaves.autostart =true
	if SceneManager.player:
		$Player.global_position = $Entrances/any.global_position
@onready var current_level = Global.level

@onready var enemy_count = {
	1:2,
	2:4,
	3:6,
	4:8,
	5:10
}
@onready var enemy = preload("res://Enemies/enemy.tscn")
@onready var rand = RandomNumberGenerator.new()
@onready var dead_enemies = 0
func enemy_death():
	dead_enemies += 1
	if treasure_label != null:
		treasure_label.text = "Level: "+str(current_level)+"\n"+"Enemies: "+str(enemy_count[current_level]-dead_enemies)
	if dead_enemies==enemy_count[current_level]:
		$CooldownBetweenWaves.start()
		dead_enemies=0
func spawn_enemies():
	for i in range(enemy_count[current_level]):
		
		var enemy_node = enemy.instantiate()
		var spawn_amount=$SpawnHolder.get_child_count()-1
		var rand_num = rand.randi_range(0, spawn_amount)
		var spawn_pos = $SpawnHolder.get_child(rand_num).position
		enemy_node.position=spawn_pos
		enemy_node.treasure = $Treasure
		add_child(enemy_node)
		await get_tree().create_timer(1).timeout
func update_level(level):
	if treasure_label!=null:
		
		treasure_label.text = "Level: "+str(level)+"\n"+"Enemies: "+str(enemy_count[level]-dead_enemies)
	spawn_enemies()
func _on_cooldown_between_waves_timeout() -> void:
	
	Global.level+=1
	current_level = Global.level
	
	update_level(current_level)



func _on_restart_button_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
	restart_ui.visible = false
	print("reload")


func _on_save_button_pressed() -> void:
	player.stamina.value = 0
	player.timer.start()
	var saving = SaveGame.new()
	saving.player_pos = player.global_position
	saving.player_health = player.healthbar.value
	saving.player_score = player.score
	saving.global_score = Global.score
	saving.global_hp = Global.hp
	saving.level = Global.level
	saving.player_inv = inv.itemsList.slots
	ResourceSaver.save(saving, save_path)
