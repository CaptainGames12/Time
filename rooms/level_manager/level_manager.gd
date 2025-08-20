extends Node2D
@export var treasure: Node2D
@export var player: Player
@export var level_progress: TextureProgressBar
@export var boss_level: int
@export var boss_track: AudioStream
@export var stage_completed: RichTextLabel
@export var scene_changer: Area2D

@onready var stage_label_tween: Tween

@export var boss_healthbar: Control
@onready var main_music: AudioStreamPlayer= %MainMusic
@export var entrance_anim: AnimatedSprite2D

@onready var enemy_count: Dictionary[int, int] = {
	1:2,
	2:4,
	3:6,
	4:8,
	5:1
}
@onready var current_level = 1

@export var boss_scene: PackedScene
@onready var boss_node = boss_scene.instantiate()
@onready var enemy = preload("res://enemies/forest/clock_enemy/enemy.tscn")

@onready var rand = RandomNumberGenerator.new()
@onready var dead_enemies = 0
@onready var cooldown_timer: Timer = get_node("CooldownBetweenWaves")
func _ready() -> void:
	cooldown_timer.timeout.connect(_on_cooldown_between_waves_timeout)
	cooldown_timer.autostart =true
	SignalBus.entered_the_shop.connect(pause_stage_tween)
	SignalBus.exited_the_shop.connect(start_stage_tween)
	if %TimeControlManager.loader!=null:
		current_level=%TimeControlManager.loader.level
		SignalBus.need_shop_opened.emit()
	else:
		get_tree().paused=true
		SignalBus.need_shop_closed.emit()
	
func _process(_delta: float) -> void:
	var enemies_are_here = []
	for i in get_children():
		if i.is_in_group("enemy"):
			enemies_are_here.append(i)
	if cooldown_timer.is_stopped() and enemies_are_here.is_empty() and boss_scene==null:
		show_stage_completed()
		SignalBus.need_shop_opened.emit()
		current_level+=1
		cooldown_timer.start()
		
		dead_enemies=0
	if boss_node.is_inside_tree():
		boss_healthbar.get_child(0).value = boss_node.health
		pass

func enemy_death():
	dead_enemies += 1
	
	if dead_enemies==enemy_count[current_level]:
		show_stage_completed()
		start_stage_tween()
		SignalBus.need_shop_opened.emit()
		current_level+=1
		cooldown_timer.start()
		dead_enemies=0
		
func spawn_enemies():
	if current_level<boss_level:
		for i in range(enemy_count[current_level]):
			var enemy_node = enemy.instantiate()
			var spawn_amount = get_child_count()-1
			var rand_num = rand.randi_range(0, spawn_amount)
			var rand_spawn_node = get_child(rand_num)
			while(!rand_spawn_node.is_class("Node2D")):
				print(rand_spawn_node.get_class())
				rand_num = rand.randi_range(0, spawn_amount)
				rand_spawn_node = get_child(rand_num)
			var spawn_pos = rand_spawn_node.global_position
			enemy_node.position = spawn_pos
			enemy_node.treasure = treasure
			add_child(enemy_node)
			await get_tree().create_timer(1, false).timeout
	elif current_level==boss_level:
		main_music.stream = boss_track
		
		main_music.play()
		
		add_child(boss_node)
		boss_node.hit_player.connect(player.boss_hit)
		boss_healthbar.get_child(0).value= boss_node.health
		boss_healthbar.get_child(0).max_value= boss_node.health
		boss_healthbar.visible = true
		
func update_level():
	if level_progress!=null:
		level_progress.value = current_level
		level_progress.get_child(0).value=current_level-1
	spawn_enemies()
func _on_cooldown_between_waves_timeout() -> void:
	SignalBus.need_shop_closed.emit()
	update_level()

func show_stage_completed():
	stage_label_tween = get_tree().create_tween().chain()
	stage_label_tween.tween_property(stage_completed, "visible_ratio", 1, 3)
	stage_label_tween.tween_interval(0.5)
	stage_label_tween.tween_property(stage_completed, "visible_ratio", 0, 3)
	stage_label_tween.finished.connect(stage_label_tween.kill)
func pause_stage_tween():
	if stage_label_tween!=null:
		stage_label_tween.pause()
		stage_completed.visible=false	
func start_stage_tween():
	if stage_label_tween!=null:
		stage_label_tween.play()
		stage_completed.visible=true	
