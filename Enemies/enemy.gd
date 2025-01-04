extends CharacterBody2D
@onready var treasure: Sprite2D = $"../Treasure"
@onready var nav: NavigationAgent2D = $NavigationAgent2D
@export var health = 4
@onready var sprite = $AnimatedSprite2D
@export var speed = 200
@onready var health_bar: ProgressBar = $ProgressBar
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	health_bar.max_value = health
	health_bar.value = health
var target = null
var targetIsHere = false
var attack = false
var tresDistance = null
var targetDistance = null
var dist = false
func _on_detection_body_entered(body):
	target = body
	
	
	targetIsHere = true

func _process(delta):
	health_bar.value = health
	var direction
	if target!=null and treasure != null:
		nav.target_position=target.position
		tresDistance = (treasure.position - position)
		targetDistance = (target.position - position)  
		dist = tresDistance<targetDistance
	if dist and treasure != null:
		direction = (treasure.position - position)
		direction = direction.normalized()
		velocity = velocity.lerp(direction*speed, 1)
	elif targetIsHere:
		nav.target_position=target.position
		direction = (nav.get_next_path_position() - global_position)
		direction = direction.normalized()
		velocity = velocity.lerp(direction*speed, 1)
		if target.position.y > position.y:
			sprite.play("down")
		elif target.position.x< position.x:
			sprite.play("left")
			sprite.flip_h = true
		elif target.position.x>position.x:
			sprite.play("right")
			sprite.flip_h = false
	move_and_slide()
func _on_detection_body_exited(body):
	target=null
	targetIsHere= false
	sprite.play("default")



func _on_attack_body_entered(body):
	animation_player.play("attack")
	body.healthbar.value -=1
	if body.healthbar.value <= 1:
		body.queue_free()
