extends Area2D

@export var speed: = 500

var target_fire: Vector2
@onready var boss=get_node("/root/Forest/EvilClockBoss")
@onready var player=get_node("/root/Forest/Player")
func _physics_process(delta):
	position-=target_fire*speed*delta
	
	
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
	
func player_getter():
	if player!=null:
		return player
		
func _on_body_entered(body: Player):
	SignalBus.health_changed.emit(-1, "health")
	if boss!=null and body!=null:
		boss.finishing_player(player_getter())
	queue_free()
