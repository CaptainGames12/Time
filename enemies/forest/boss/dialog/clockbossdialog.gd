extends RichTextLabel

var current_state = Text_state.ONREADY
var next_text = ""

var place = 1
enum Text_state{
	ONREADY,
	GEN,
	FINISHED
}
@export var voice:AudioStreamPlayer
@onready var tween_dialog =  get_tree().create_tween().set_pause_mode(Tween.TweenPauseMode.TWEEN_PAUSE_PROCESS)
func _process(delta: float) -> void:
	
	match current_state:
		Text_state.ONREADY:
			
			$"../..".visible = true
			if place<=Texts.clockphrases.size():
				next_text = Texts.clockphrases[place]
			else:
				get_parent().get_parent().queue_free()
				get_parent().get_parent().get_parent().get_parent().get_node("MainMusic").playing=true
			generate_dialogue(next_text)
		Text_state.GEN:
			
			if Input.is_action_just_pressed("continue"):
				
				visible_ratio = 1
				tween_dialog.kill()
				state_changer(Text_state.FINISHED)
		Text_state.FINISHED:
			
			if Input.is_action_just_pressed("continue") and Texts.place!=2:
				
				$"../..".visible = false
				state_changer(Text_state.ONREADY)
				place+=1
func generate_dialogue(my_text = next_text):
	
	
	visible_ratio = 0
	text = my_text
	state_changer(Text_state.GEN)
	tween_dialog = get_tree().create_tween().set_pause_mode(Tween.TweenPauseMode.TWEEN_PAUSE_PROCESS)
	generate_dialogue_audio()
	tween_dialog.tween_property(self, "visible_ratio", 1, 2)
	tween_dialog.connect("finished", anim_finished)
func generate_dialogue_audio():
	while tween_dialog.is_running():
		voice.play()
		await get_tree().create_timer(0.1).timeout
func anim_finished():
	state_changer(Text_state.FINISHED)
func state_changer(next_state):
	current_state = next_state
	match next_state:
		Text_state.ONREADY:
			print("is on ready")
		Text_state.GEN:
			print("generating")
		Text_state.FINISHED:
			print("finished")
