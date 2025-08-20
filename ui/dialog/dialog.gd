extends RichTextLabel
@export var root_node: Node2D
@export var root_of_tutorial_dialog: Control
@export var spell_joystick: Node2D
@export var time_manager: Node
enum Text_state
{
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
var bought_item=false
@onready var player = get_tree().root.get_node("Forest/Player")
@onready var main = get_tree().root.get_node("Forest")
@onready var tween_dialog =  get_tree().create_tween().set_pause_mode(Tween.TweenPauseMode.TWEEN_PAUSE_PROCESS)
@export var voice: AudioStreamPlayer2D

func buttons_disable():
	if btn_save != null and btn_stop!=null:
		btn_save.action="nothing"
		btn_stop.action="nothing"
func _ready() -> void:
	root_node = get_tree().root.get_child(get_child_count()-1)
	if root_node.name!="Forest":
		print(root_node.name)
		root_of_tutorial_dialog.queue_free()
	state_changer(Text_state.ONREADY)
	if spell_joystick!=null:	
		spell_joystick.process_mode=Node.PROCESS_MODE_PAUSABLE
	buttons_disable()
	if Texts.place!=10:
		DialogSignals.tutorial_started.emit()
		DialogSignals.tutorial_started.connect(start)
		DialogSignals.bought.connect(got_item)
		DialogSignals.out_of_the_shop.connect(cast_spell)
		DialogSignals.shoot.connect(shoot)
		DialogSignals.tutorial_finished.connect(finish)
		DialogSignals.time_save_pressed.connect(save_pressed)
		DialogSignals.time_stop_pressed.connect(stop_pressed)
		DialogSignals.mixed_elements.connect(shoot_mixed)
	if time_manager!=null:
		if time_manager.loader!=null:	
		
			DialogSignals.tutorial_finished.emit()
var shoot_counter=0	
func _process(_delta: float) -> void:

	match current_state:
		Text_state.ONREADY:
			
			$"../..".visible = true
			next_text = Texts.timeline[Texts.place]
			generate_dialogue(next_text)
		Text_state.GEN:
			
			if Input.is_action_just_pressed("continue"):
				voice.stop()
				visible_ratio = 1
				tween_dialog.kill()
				state_changer(Text_state.FINISHED)
		Text_state.FINISHED:
			
			if Input.is_action_just_pressed("continue") and Texts.place!=2:
				$"../../AudioStreamPlayer2D".stop()
				$"../..".visible = false
				tween_dialog.kill()
				if Texts.place<3:	
					state_changer(Text_state.ONREADY)
				
				if isSkipped or Texts.place==6:
					is_tutorial_here = false
					DialogSignals.tutorial_finished.emit()
					
					
				if !isTutorialStarted and Texts.place!=10:
					Texts.place+=1
				if Texts.place == 10:
					DialogSignals.forest_end.emit()
func finish():
	get_tree().paused = false
	get_parent().get_parent().queue_free()
func save_pressed():
	Texts.place=6
	state_changer(Text_state.ONREADY)
func got_item():
	Texts.place=4
	bought_item=true
	state_changer(Text_state.ONREADY)
func cast_spell():
	if bought_item:
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
		
		shoot_counter+=1
		if shoot_counter==1:
			Texts.place=11
			state_changer(Text_state.ONREADY)
			DialogSignals.shoot.disconnect(shoot)
func shoot_mixed():	
	DialogSignals.shoot.connect(mix_elements)
func mix_elements():
	
	shoot_counter=0
	shoot_counter+=1
	if shoot_counter==1:
		btn_stop.action="time_stop"
		Texts.place=8
		state_changer(Text_state.ONREADY)	

func generate_dialogue(my_text = next_text):
	
	visible_ratio = 0
	text = my_text
	state_changer(Text_state.GEN)
	
	tween_dialog = get_tree().create_tween().set_pause_mode(Tween.TweenPauseMode.TWEEN_PAUSE_PROCESS)
	generate_dialogue_audio()
	tween_dialog.tween_property(self, "visible_ratio", 1, 2)
	
	tween_dialog.connect("finished", anim_finished)
	
	if Texts.place==3:
		DialogSignals.go_to_the_shop.emit()
func generate_dialogue_audio():
	while tween_dialog.is_running():
		voice.play()
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
		btn_save.action="time_save"
		btn_stop.action="time_stop"
	
		spell_joystick.process_mode=Node.PROCESS_MODE_ALWAYS
		isSkipped = true
		
func start():
	isTutorialStarted = false
		
func state_changer(next_state):
	current_state = next_state
	
