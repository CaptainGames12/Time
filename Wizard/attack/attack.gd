extends Area2D

@export var speed := 500

@onready var bossHealth: Control = get_parent().get_node("CanvasLayer/ProgressBars/Boss_health")
@onready var dialogs = get_parent().get_node_or_null("CanvasLayer/Dialogs")
@onready var spell_manager: Node = %SpellManager

var elements = SpellMixer.chosen_items
var target_fire: Vector2
var coin = preload("res://shopping/coin.tscn").instantiate()
var ready_elements: Array[String] = []

var script_for_manager
signal deadBoss

func _ready() -> void:
	deadBoss.connect(get_node("/root/Node2D").the_end)
	DialogSignals.shoot.emit()
	if dialogs != null:
		process_mode = Node.PROCESS_MODE_ALWAYS
	preparing_spell()
	look_at(target_fire)
	
	
	
func preparing_spell():
	for i in elements:
		if i != null:
			ready_elements.append(i.item_name)
	SpellMixer.spell= SpellMixer.mix(ready_elements)
	if SpellMixer.spell != null:
		spell_manager.set_script(SpellMixer.spell.effect)
		spell_manager.spell = SpellMixer.spell
		$Sprite2D.texture = SpellMixer.spell.texture
		if spell_manager.has_method("spawn_area"):
			spell_manager.spawn_area(get_parent(), spell_manager.spell.particle, position)
		if SpellMixer.spell.audio!=null:
			AttackSfx.stream = SpellMixer.spell.audio
			AttackSfx.play()	

func _physics_process(delta: float) -> void:
	if spell_manager.has_method("_physics_process"):
		spell_manager._physics_process(delta)
	position += target_fire * speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if SpellMixer.spell == null:
		return
	if spell_manager.has_method("spawn_area"):
		spell_manager.call_deferred("spawn_area", get_parent(), spell_manager.spell.particle, position)
	spell_manager.reparent(body)
	body.get_node("SpellManager").apply_effect(body)
	
	queue_free()

func spawn_particle(target: Node = null) -> void:
	var particle_instance = SpellMixer.spell.particle.instantiate()
	if target == null:
		add_child(particle_instance)
	else:
		target.add_child(particle_instance)
		if target.has_method("move_child"):
			target.move_child(find_child("fire"), -1)
