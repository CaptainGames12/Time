extends Area2D

@export var speed := 500

@onready var bossHealth: Control = get_parent().get_node("Interface/ProgressBars/Boss_health")
@onready var dialogs = get_parent().get_node_or_null("CanvasLayer/Dialogs")
@onready var spell_manager: Node = %SpellManager

var elements = SpellMixer.chosen_items
var target_fire: Vector2
var coin = preload("res://shopping/coin.tscn").instantiate()
var ready_elements: Array[String] = []



func _ready() -> void:
	DialogSignals.shoot.emit()
	if dialogs != null:
		process_mode = Node.PROCESS_MODE_ALWAYS
	mix_elements()
	preparing_spell()
	look_at(target_fire)
## This method is used for making spell with elements and attaching script with effect to SpellManager.
## If spell is Static then we use spawn_area method.	
func mix_elements():
	for i in elements:
		if i != null:
			ready_elements.append(i.item_name)
	SpellMixer.spell= SpellMixer.mix(ready_elements)
func preparing_spell():
	
	if SpellMixer.spell != null and SpellMixer.spell.effect!=null:
		
		spell_manager.set_script(SpellMixer.spell.effect)
		spell_manager.spell = SpellMixer.spell
		$Sprite2D.texture = SpellMixer.spell.texture
		
		if spell_manager.has_method("spawn_area"):
			spell_manager.spawn_area(get_parent(), spell_manager.spell.spawn_area, position)
		if SpellMixer.spell.audio!=null:
			AttackSfx.stream = SpellMixer.spell.audio
			AttackSfx.play()	

func _physics_process(delta: float) -> void:
	if spell_manager.has_method("_physics_process"):
		spell_manager._physics_process(delta)
	position += target_fire * speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
## Here we use _on_body_entered to reparent SpellManager to enemy and call apply_effect.
## It's made this way so that it was more safe, because our attack/bullet entity can be removed at any moment.
func _on_body_entered(body: Node2D) -> void:
	if SpellMixer.spell == null:
		return
	if spell_manager.has_method("spawn_area"):
		spell_manager.call_deferred("spawn_area", get_parent(), spell_manager.spell.spawn_area, position)
	else:
		if body.is_in_group("enemy"):	
			if body.get_node_or_null("SpellManager")==null:
				spell_manager.reparent(body)
				body.get_node("SpellManager").apply_effect(body)
			elif body.get_node("SpellManager").is_class("Bullet"):
				body.get_node("SpellManager").queue_free()
				spell_manager.reparent(body)
			
		if body.is_in_group("boss"):
			if !body.isProtected:
				if body.get_node_or_null("SpellManager")==null:
					spell_manager.reparent(body)
				else:
					body.get_node("SpellManager").queue_free()
				body.get_node("SpellManager").apply_effect(body)
	
	queue_free()
