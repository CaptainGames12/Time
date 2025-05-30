extends Area2D


@export var speed := 500

@onready var bossHealth: Control = get_parent().get_node("CanvasLayer/ProgressBars/Boss_health")
@onready var dialogs = get_parent().get_node_or_null("CanvasLayer/Dialogs")

var elements = SpellMixer.chosen_items
var target_fire: Vector2
var coin = preload("res://shopping/coin.tscn").instantiate()
var ready_elements: Array[String] = []
var spell

signal deadBoss

func _ready() -> void:
	for i in elements:
		if i != null:
			ready_elements.append(i.item_name)

	look_at(target_fire)

	if dialogs != null:
		process_mode = Node.PROCESS_MODE_ALWAYS

	spell= SpellMixer.mix(ready_elements)
	deadBoss.connect(get_node("/root/Node2D").the_end)
	DialogSignals.shoot.emit()

	if spell != null:
		$Sprite2D.texture = spell.texture
		if spell.audio!=null:
			AttackSfx.stream = spell.audio
			AttackSfx.play()

		if spell.item_name == "smoke":
			monitoring=false
			spawn_particle()
			await get_tree().create_timer(0.3).timeout
			speed = 0
		if spell.item_name=="fire wall" or spell.item_name=="blizzard" or spell.item_name=="wall":
			var spell_particle=spell.particle.instantiate()
			spell_particle.rotation_degrees=rotation_degrees+90
			add_child(spell_particle)
			
			await get_tree().create_timer(0.3).timeout
			var particle_node=spell.particle.instantiate()
			get_parent().add_child(particle_node)
			particle_node.rotation_degrees=rotation_degrees+90
			particle_node.position=position
			if particle_node.has_method("dmg"):
				particle_node.dmg=spell.damage
			queue_free()

func _physics_process(delta: float) -> void:
	position += target_fire * speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if spell == null:
		return

	if body.is_in_group("tree") and spell.item_name == "fire":
		body.add_child(spell.particle.instantiate())
		body.move_child(find_child("fire"), -1)
		if body.has_method("fired"):
			body.fired()

	elif body is Enemy or body is ClockBoss:
		apply_spell_effects(body)

		if body is ClockBoss and not body.isProtected:
			body.boss_health -= spell.damage
			bossHealth.get_child(0).value -= spell.damage

			if body.boss_health <= 0:
				body.queue_free()
				deadBoss.emit()

	queue_free()

func _on_timer_timeout() -> void:
	if spell != null and spell.item_name == "earth":
		var rockNode = preload("res://spells/earth/rock.tscn").instantiate()
		get_parent().add_child(rockNode)
		rockNode.position = position



func apply_spell_effects(body: Node2D) -> void:
	match spell.item_name:
		"fire":
			spawn_particle(body)
			if body.has_method("fired"):
				body.fired()
		"ice":
			if body.has_method("frozen"):
				body.frozen()
		"earth":
			if body.has_method("earthed"):
				body.earthed()
		"wind":
			if body.has_method("winded"):
				body.winded(target_fire)
		"water":
			if body.has_method("watered"):
				body.watered()
		"fire wall":
			var fire_wall_node=spell.particle.instantiate()
			get_parent().add_child(fire_wall_node)
			fire_wall_node.position=position
		"wall":
			var wall_node=spell.particle.instantiate()
			get_parent().add_child(wall_node)
			wall_node.position=position
			
	body.health -= spell.damage
	print(body.health)

func spawn_particle(target: Node = null) -> void:
	var particle_instance = spell.particle.instantiate()
	if target == null:
		add_child(particle_instance)
	else:
		target.add_child(particle_instance)
		if target.has_method("move_child"):
			target.move_child(find_child("fire"), -1)
