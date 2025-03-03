extends Base_Scene
@onready var treasure_label = $Treasure/Label
@onready var restart_ui: Control = $Player/CanvasLayer/RestartUI/RestartButton
@onready var inv = %Control
var save_path = "user://file.tres"
@onready var texture_rect: TextureRect = $TextureRect
@onready var current_level = 1
@onready var saver = ResourceSaver
@onready var loader = ResourceLoader.load(save_path, "", 2) as SaveGame
var saving = SaveGame.new()

func _ready():
	
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
		current_level+=1
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
	
	update_level(current_level)
		
	
func _on_restart_button_pressed() -> void:

	get_tree().paused = false
	
	get_tree().reload_current_scene()
	restart_ui.visible = false
	print("reload")


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
