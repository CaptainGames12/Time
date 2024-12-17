extends CharacterBody2D
@onready var treasure: Sprite2D = $"../Treasure"

@onready var sprite = $AnimatedSprite2D
@export var speed = 200

var target = null
var targetIsHere = false
var attack = false
var tresDistance = null
var targetDistance = null
var dist = false
func _on_detection_body_entered(body):
	target=body
	targetIsHere = true

func _physics_process(delta):
	if target!=null and treasure != null:
		tresDistance = (treasure.position - position)
		targetDistance = (target.position - position)  
		dist = tresDistance<targetDistance
	if dist and treasure != null:
		position += (treasure.position - position)/speed
	elif targetIsHere:
		position += (target.position - position)/speed
		if target.position.y > position.y:
			sprite.play("down")
		elif target.position.x< position.x:
			sprite.play("left")
			sprite.flip_h = true
		elif target.position.x>position.x:
			sprite.play("right")
			sprite.flip_h = false
			
func _on_detection_body_exited(body):
	target=null
	targetIsHere= false
	sprite.play("default")



func _on_attack_body_entered(body):
	body.healthbar.value -=1
	if body.healthbar.value <= 0:
		body.queue_free()
