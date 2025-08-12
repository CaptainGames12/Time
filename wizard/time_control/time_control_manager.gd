extends Node
@export var ui: CanvasLayer
@export var darkness_falling: ColorRect
@export var stop_pressed_cooldown: Timer
@export var stop_audio: AudioStreamPlayer
@export var restart_ui: Control
@export var time_stop_screen_fx: ColorRect
@export var dialogs: Control
@export var player: Player
@export var healthbar: Control
@export var inventory: Control
@export var entrance: Marker2D
@export var treasure: Node2D
@export var stamina: TextureProgressBar
@export var stamina_timer: Timer
@export var restart_button: TextureButton
@export var ring_effect: ColorRect
var in_the_shop: bool = false
var is_restarted: bool =false
var time_stop_visualize_switch: bool =1
var ring_active : bool = false
var start_time : int = 0
var ring_duration := 1000 
var stamina_value := 10
var save_path = "user://save.tres"
var saving = SaveGame.new()
@onready var saver = ResourceSaver
@onready var loader = ResourceLoader.load(save_path) as SaveGame
func _ready() -> void:
	SignalBus.game_over.connect(game_over)
	stop_pressed_cooldown.timeout.connect(stop_time_after_cooldown)
	stamina_timer.timeout.connect(_on_stamina_timer_timeout)
	restart_button.pressed.connect(_on_restart_button_pressed)
func trigger_ring():
	ring_active = true
	start_time = Time.get_ticks_msec()
	ring_effect.visible = true
func _on_restart_button_pressed() -> void:
	if !is_restarted:
		is_restarted=true
		%MainMusic.stream=preload("res://wizard/fx_continue.mp3")
		
		%MainMusic.connect("finished", reset)
		%MainMusic.play()
func reset():
		Texts.place=1
		
		var tween = get_tree().create_tween()
		tween.set_pause_mode(Tween.TweenPauseMode.TWEEN_PAUSE_PROCESS)
		
		print(tween.is_running())
		tween.tween_property($Sprite2D, "scale", Vector2(0, 0), 0.5)
		tween.tween_property(restart_ui, "modulate", Color(0, 0, 0, 0), 0.5)
		tween.finished.connect(get_tree().change_scene_to_file.bind("res://ui/loading.tscn"))
func _process(_delta: float) -> void:
	if ring_active:
		var now = Time.get_ticks_msec()
		var elapsed = now - start_time
		var progress = float(elapsed) / ring_duration
		ring_effect.material.set_shader_parameter("progress", progress)

		if progress >= 1.0:
			ring_active = false
			ring_effect.visible = false
func _physics_process(_delta: float) -> void:

	if get_tree().paused==true and dialogs==null and !in_the_shop:	
		time_stop_visualize_switch=1
	else:
		time_stop_visualize_switch=0	
	time_stop_screen_fx.material.set_shader_parameter("enabled", time_stop_visualize_switch)
	stop_time()
	time_save()
func _on_stamina_timer_timeout() -> void:
	if get_tree().paused == true:
		match stamina_value>0:
			true:
				SignalBus.stamina_changed.emit(-1, "stamina")
				stamina_value = clamp(stamina_value-1, 0, 10)
			false:
				get_tree().paused = false
				
	if get_tree().paused == false:
		SignalBus.stamina_changed.emit(1, "stamina")
		stamina_value = clamp(stamina_value+1, 0, 10)
func stop_time():
	if Input.is_action_just_pressed("time_stop"):
		if stop_pressed_cooldown.is_stopped():
			stop_audio.play()
			stop_pressed_cooldown.start()
	
func stop_time_after_cooldown():
	if dialogs==null and !in_the_shop and treasure!=null:
		get_tree().paused = !get_tree().paused
		stamina_timer.start()
		
		time_stop_visualize_switch=!time_stop_visualize_switch
		trigger_ring()	

	DialogSignals.time_stop_pressed.emit()
func load_save():
	if loader != null:	
		
		player.global_position = loader.player_pos
		
		get_parent().current_level = loader.level
		Global.collected_items = loader.collected_items
		Global.score = loader.global_score 
		Global.hp = loader.global_hp
		SignalBus.health_changed.emit(0)
		inventory.itemsList.slots = loader.player_inv
		inventory.update_slots()
		get_tree().paused=false
		
	else:
		player.global_position = entrance.global_position
		printerr("isn't loaded")	
func time_save() -> void:
	if Input.is_action_just_pressed("time_save"):
		if treasure!=null:
			if stamina_value==10:
				SignalBus.progress_saved.emit()
				
				DialogSignals.time_save_pressed.emit()
				stamina_value = 0
				SignalBus.stamina_changed.emit(-10, "time")
				stamina_timer.start()
				
				saving.collected_items = Global.collected_items
				saving.player_pos = player.global_position
				
				saving.global_score = Global.score
				saving.global_hp = Global.hp
				saving.level = get_parent().current_level
				saving.player_inv = inventory.itemsList.slots
				
				saver.save(saving, save_path)
func game_over():
	for i in ui.get_children():
		for j:Node in i.get_children():
			if j.name!="RestartUI":
				j.process_mode = Node.PROCESS_MODE_DISABLED
				if j.has_method("visible"):
					j.visible = false
	game_over_anim()

func game_over_anim():
	
	restart_ui.get_node("Clock").game_over=true
	darkness_falling.global_position=treasure.position
	darkness_falling.visible=true
	var tween = get_tree().create_tween()
	tween.set_pause_mode(Tween.TweenPauseMode.TWEEN_PAUSE_PROCESS)
			
	tween.tween_property(darkness_falling, "scale", Vector2(60, 60), 5)
	get_parent().get_node("MainMusic").stream=preload("res://wizard/game_over_without_ticking.mp3")
	get_parent().get_node("MainMusic").process_mode = Node.PROCESS_MODE_ALWAYS
	tween.finished.connect(get_parent().get_node("MainMusic").play)
	get_tree().paused = true
	restart_ui.visible = true
	tween.tween_property(restart_ui, "modulate", Color(1, 1, 1, 1), 2)
	tween.finished.connect(print.bind("darkness fell"))
	tween.finished.connect(turn_on_restart)
	tween.finished.connect(tween.kill)
	
func turn_on_restart():
	restart_ui.get_node("RestartButton").disabled=false
