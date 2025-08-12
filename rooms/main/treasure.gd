extends Sprite2D
@onready var player: Player = $"../Player"
@export var restart_ui: Control

@export var treasureDurability: int
@onready var durabilityBar: ProgressBar = $Durability
var is_tutorial_started = false
func _on_area_2d_body_entered(body: Area2D) -> void:
	if body.is_in_group("attack_area"):
		if treasureDurability<=0:
			SignalBus.game_over.emit()
			queue_free()
func the_end_of_forest():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color(0, 0, 0, 0), 1)
	tween.finished.connect(queue_free)		
	
