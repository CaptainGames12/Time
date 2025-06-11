extends Control
@onready var path = Global.current_scene
func _ready() -> void:
	print(path)
	get_tree().paused=false
	ResourceLoader.load_threaded_request(path)
func _process(delta: float) -> void:
	var show_progress = []
	ResourceLoader.load_threaded_get_status(path, show_progress)
	$ProgressBar.value = show_progress[0]*100
	if show_progress[0]==1:
		var packed_scene = ResourceLoader.load_threaded_get(path)
		get_tree().change_scene_to_packed(packed_scene)
