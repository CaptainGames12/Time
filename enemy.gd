extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D
@export var speed = 10
var player = null
var playerIsHere = false
func _on_detection_body_entered(body):
	player=body
	playerIsHere = true

func _physics_process(delta):
	if playerIsHere:
		position += (player.position - position)/speed
		if player.position.y > position.y:
			sprite.play("down")
		elif player.position.x< position.x:
			sprite.play("left")
			sprite.flip_h = true
		elif player.position.x>position.x:
			sprite.play("right")
			sprite.flip_h = false
			
func _on_detection_body_exited(body):
	player=null
	playerIsHere = false
	sprite.play("default")


func _on_attack_body_entered(body):
	body.queue_free()
