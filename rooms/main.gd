extends Base_Scene

func _ready():
	if SceneManager.player:
		$Player.global_position = $Entrances/any.global_position
