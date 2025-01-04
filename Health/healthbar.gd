extends TextureProgressBar

@onready var damage: ProgressBar = $Damage
@onready var timer: Timer = $Timer
@onready var health = 0: set = _set_healthbar
func _set_healthbar(new_health):
	var prev_health = health
	health = min(min_value, new_health)
	value = health
	
	if health < prev_health:
		timer.start()
	else:
		damage.value = health
func init_health(_health):
	health = _health
	max_value = health
	value = health
	damage.max_value = health
	damage.value = health
func _on_timer_timeout() -> void:
	damage.value = health
