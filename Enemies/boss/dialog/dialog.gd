extends RichTextLabel

enum Text_state{
	ONREADY,
	GEN,
	FINISHED
}
var isSkipped =false
@onready var btn_stop=get_parent().get_parent().get_parent().get_node("TimeControl/TimeStop")
@onready var btn_save=get_parent().get_parent().get_parent().get_node("TimeControl/Saving/SaveButton")
var current_state = Text_state.ONREADY
var next_text = ""
var isTutorialStarted:bool
var is_tutorial_here = true
@onready var player = get_tree().root.get_node("Node2D/Player")
@onready var main = get_tree().root.get_node("Node2D")
@onready var tween_dialog =  get_tree().create_tween().set_pause_mode(2)
func buttons_disable():
	btn_save.action="nothing"
	btn_stop.action="nothing"
func _ready() -> void:
	main.get_node("CanvasLayer/Joysticks/SpellJoystick").process_mode=Node.PROCESS_MODE_PAUSABLE
	buttons_disable()
	DialogSignals.tutorial_started.emit()
	DialogSignals.tutorial_started.connect(start)
	DialogSignals.bought.connect(got_item)
	DialogSignals.out_of_the_shop.connect(cast_spell)
	DialogSignals.shoot.connect(shoot)
	DialogSignals.tutorial_finished.connect(finish)
	DialogSignals.time_save_pressed.connect(save_pressed)
	DialogSignals.time_stop_pressed.connect(stop_pressed)
	if player.loader==null:	
		get_tree().paused=true
var shoot_counter=0	
func _process(delta: float) -> void:
	
	match current_state:
		Text_state.ONREADY:
			
			$"../..".visible = true
			next_text = Texts.timeline[Texts.place]
			generate_dialogue(next_text)
		Text_state.GEN:
			
			if Input.is_action_just_pressed("continue"):
				$"../../AudioStreamPlayer2D".stop()
				visible_ratio = 1
				tween_dialog.kill()
				state_changer(Text_state.FINISHED)
		Text_state.FINISHED:
			
			if Input.is_action_just_pressed("continue") and Texts.place!=2:
				$"../../AudioStreamPlayer2D".stop()
				$"../..".visible = false
				if Texts.place<3:	
					state_changer(Text_state.ONREADY)
				
				if isSkipped or Texts.place==6:
					is_tutorial_here = false
					DialogSignals.tutorial_finished.emit()
					get_tree().queue_delete($"../..")
				if Texts.place==10:
					DialogSignals.forest_end.emit()
				if !isTutorialStarted:
					Texts.place+=1
func finish():
	get_tree().paused = false
func save_pressed():
	Texts.place=6
	state_changer(Text_state.ONREADY)
func got_item():
	Texts.place=4
	
	state_changer(Text_state.ONREADY)
func cast_spell():
	Texts.place=5
	
	main.get_node("CanvasLayer/Joysticks/SpellJoystick").process_mode=Node.PROCESS_MODE_ALWAYS
	
	main.call_deferred("close_shop")
	state_changer(Text_state.ONREADY)
func stop_pressed():
	Texts.place=9
	btn_save.action="time_save"
	state_changer(Text_state.ONREADY)	
func shoot():
	if player.in_the_shop==false:
		btn_stop.action="time_stop"
		shoot_counter+=1
		if shoot_counter==1:
			Texts.place=8
			state_changer(Text_state.ONREADY)	
func generate_dialogue(my_text = next_text):
	
	
	visible_ratio = 0
	text = my_text
	state_changer(Text_state.GEN)
	tween_dialog = get_tree().create_tween().set_pause_mode(2)
	tween_dialog.tween_property(self, "visible_ratio", 1, 2)
	tween_dialog.connect("finished", anim_finished)
	if Texts.place==3:
		DialogSignals.go_to_the_shop.emit()
func generate_dialogue_audio():
	while tween_dialog.is_running():
		.play()
		await get_tree().create_timer(0.1).timeout
func anim_finished():
	state_changer(Text_state.FINISHED)
	
	
func answer(value:Variant):
	if str(value)=="positive_answer":
		current_state = Text_state.ONREADY
		isTutorialStarted = true
		Texts.place+=1
	if str(value)=="negative_answer":
		generate_dialogue(Texts.skipping)
		Texts.place+=1
		isSkipped = true
		
func start():
	isTutorialStarted = false
		
func state_changer(next_state):
	current_state = next_state
	match next_state:
		Text_state.ONREADY:
			print("is on ready")
		Text_state.GEN:
			print("generating")
		Text_state.FINISHED:
			print("finished")
