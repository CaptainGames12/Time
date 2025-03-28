extends Area2D

@export var speed: = 500

var target_fire: Vector2
@onready var boss=get_node("/root/Node2D/EvilClockBoss")
@onready var player=get_node("/root/Node2D/Player")
func _physics_process(delta):
	position-=target_fire*speed*delta
	
	
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
	
func player_getter():
	if player!=null:
		return player
		
func _on_body_entered(body: Player):
	body.healthbar.value-=3
	Global.hp-=3
	if boss!=null:
		boss.spawning_restart(player_getter())
	queue_free()
