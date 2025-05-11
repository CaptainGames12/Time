extends Area2D

@export var elements={}
@export var speed: = 500
@onready var boss_health: Control =$".."/Player/CanvasLayer/Boss_health

var target_fire: Vector2
var COIN = preload("res://shopping/coin.tscn").instantiate()
var ready_elements:Array[String]=[]
var spell:Resource
signal deadBoss
func _ready() -> void:
	
	for i in elements.values():
		if i!=null:
			ready_elements.append(i)
	look_at(target_fire)
	if get_node("/root/Node2D/Player/CanvasLayer/Dialogs")!=null:
		process_mode=Node.PROCESS_MODE_ALWAYS
	spell = SpellMixer.mix(ready_elements)
	deadBoss.connect(get_node("/root/Node2D").the_end)
	DialogSignals.shoot.emit()
	if spell!=null:			
		$Sprite2D.texture=spell.texture
		match spell.item_name:
			
			"fire":
				AttackSfx.stream=spell.audio
				AttackSfx.play()
			"water":
				AttackSfx.stream = spell.audio
				AttackSfx.play()
			"earth":
				AttackSfx.stream = spell.audio
				AttackSfx.play()
			"wind":
				AttackSfx.stream = spell.audio
				AttackSfx.play()
				rotation=0
			"smoke":
				add_child(spell.particle.instantiate())
				await get_tree().create_timer(0.3).timeout
				speed=0
func _physics_process(delta):
	position+=target_fire*speed*delta
	
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_body_entered(body: Node2D):
	if spell!=null:
		print(body.get_class())
		if body.is_in_group("tree"):
			if spell.item_name=="fire":
				body.add_child(spell.particle.instantiate())
				body.move_child(find_child("fire"), -1)
				body.fired()
				
		if body is Enemy:
			body.health -= spell.damage
			match spell.item_name:
				"fire":
					body.add_child(spell.particle.instantiate())
					body.move_child(find_child("fire"), -1)
					body.fired()
				"ice":
					body.frozen()
				"earth":
					body.earthed()
				"wind":
					body.winded(target_fire)
				"water":
					body.watered()
				
		elif body is ClockBoss:
			if !body.isProtected:
				body.boss_health -= spell.damage
				boss_health.get_child(0).value -= spell.damage
				match spell.item_name:
					"fire":
						body.add_child(spell.particle.instantiate())
						body.move_child(find_child("fire"), -1)
						body.fired()
					"ice":
						
						body.frozen()
					"earth":
						body.earthed()
					"wind":
						body.winded(target_fire)
				if body.boss_health<=0:
					body.queue_free()
					deadBoss.emit()
	if spell.item_name!="smoke":	
		queue_free()


func _on_timer_timeout() -> void:
	if spell!=null:
		match spell.item_name:
			"earth":
				var rockNode = preload("res://spells/earth/rock.tscn").instantiate()
				get_parent().add_child(rockNode)
				rockNode.position = position
				
