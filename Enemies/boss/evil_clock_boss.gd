extends CharacterBody2D

var isAngried = false
var player=null

var target_pos = Vector2(0,0)
var SPEED = 10
var ROT_SPEED = 200

@onready var stop_vector: RayCast2D = $StopVector
@onready var locator: Area2D = $Locator

func _process(delta: float) -> void:
	if target_pos.x<position.x:
		rotation_degrees-=ROT_SPEED*delta
	if target_pos.x>position.x:
		rotation_degrees+=ROT_SPEED*delta
	if target_pos==Vector2.ZERO:
		rotation_degrees=0
		
func _physics_process(delta: float) -> void:
	if isAngried:
		velocity -= target_pos*SPEED*delta
		
		
	move_and_collide(velocity)
func _on_attack_body_entered(body: Player) -> void:
	body.healthbar.value-=2
	body.position = body.position.from_angle(PI/2)*target_pos

func _on_locator_body_entered(body: Node2D) -> void:
	if body.name=="Player":
		target_pos = (position-body.position).normalized()
		player = body
		isAngried = true
		
	if body.name == "Barrier":
		isAngried=false
		target_pos = Vector2.ZERO
		velocity = Vector2.ZERO
		
	print(body.name)
