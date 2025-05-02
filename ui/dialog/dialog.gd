extends RichTextLabel

enum Text_state{
	ONREADY,
	GEN,
	FINISHED
}
var isSkipped =false

var current_state = Text_state.ONREADY
var next_text = ""
var isTutorialStarted:bool
var is_tutorial_here = true


func _ready() -> void:
	DialogSignals.tutorial_started.emit()
	DialogSignals.tutorial_started.connect(start)
	DialogSignals.bought.connect(got_item)
	DialogSignals.out_of_the_shop.connect(cast_spell)
	DialogSignals.shoot.connect(shoot)
	DialogSignals.tutorial_finished.connect(finish)
	
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
				get_tree().get_processed_tweens()[0].kill()
				
				state_changer(Text_state.FINISHED)
		Text_state.FINISHED:
			
			if Input.is_action_just_pressed("continue") and Texts.place!=2:
				$"../../AudioStreamPlayer2D".stop()
				$"../..".visible = false
				if Texts.place<3:	
					state_changer(Text_state.ONREADY)
				
				if isSkipped or Texts.place>=6:
					is_tutorial_here = false
					DialogSignals.tutorial_finished.emit()
					get_tree().queue_delete($"../..")
					
				if !isTutorialStarted:
					Texts.place+=1
func finish():
	get_tree().paused = false
func got_item():
	Texts.place=4
	state_changer(Text_state.ONREADY)
func cast_spell():
	Texts.place=5
	state_changer(Text_state.ONREADY)	
func shoot():
	shoot_counter+=1
	if shoot_counter==1:
		Texts.place=6
		state_changer(Text_state.ONREADY)	
func generate_dialogue(my_text = next_text):
	
	$"../../AudioStreamPlayer2D".play(2)
	visible_ratio = 0
	text = my_text
	state_changer(Text_state.GEN)
	var text_appearing = get_tree().create_tween().set_pause_mode(2)
	text_appearing.tween_property(self, "visible_ratio", 1, 2)
	text_appearing.connect("finished", anim_finished)
	if Texts.place==3:
		DialogSignals.go_to_the_shop.emit()
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
