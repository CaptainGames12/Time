extends Sprite2D
var tick = 0
@onready var ticks_audio : AudioStreamPlayer = $AudioStreamPlayer
@onready var player: Player = $"../../../../Player"
var game_over = false
@onready var arrow: Sprite2D = $arrow
var restarted = false
func _physics_process(delta: float) -> void:
	if tick>=100 and !restarted and game_over:
		ticks_audio.play()
		arrow.rotation_degrees+=30
		tick=0
	if restarted:
		arrow.rotation_degrees-=10
		
	tick+=1	


func _on_restart_button_pressed() -> void:
	if Input.is_action_pressed("restart"):	
		restarted=true
