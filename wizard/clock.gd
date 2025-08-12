extends AnimatedSprite2D
var tick = 0
@onready var ticks_audio : AudioStreamPlayer = $AudioStreamPlayer
@onready var player: Player = $"../../../../Player"
var game_over = false:
	set(value):
		game_over=value
		if game_over==true:
			play("default")

var restarted = false

func _on_restart_button_pressed() -> void:
		speed_scale= 10*-1
		restarted = true
		ticks_audio.stop()
		
func _on_frame_changed() -> void:
	if !restarted:	
		ticks_audio.play()
