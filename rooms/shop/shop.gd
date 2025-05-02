extends Node2D
@onready var camera_2d: Camera2D = $"../Player/CanvasLayer/Camera2D"

@onready var control: Inventory = %Control
@onready var shop_theme: AudioStreamPlayer2D = $AudioStreamPlayer2D

@onready var texture_rect: TextureRect = $TextureRect

@onready var any_main: Marker2D = $"../Entrances/any"
@onready var any_main_pos = any_main.global_position

@onready var any: Marker2D = $Entrances/any
@onready var entrance_pos = any.global_position

@onready var shop_list = [$Collectable3, $Collectable2, $Collectable, $Collectable4]
func _ready():
	
	texture_rect.queue_free()
	
	if SceneManager.player:
		add_child(SceneManager.player)
		SceneManager.player.global_position = $Entrances/any.global_position
	var count = 0
	for i in Global.collected_items:
		count = 0
		for j in shop_list:
			if i==j.item_name:
				shop_list[count].queue_free()
				shop_list.remove_at(count)
				
			count+=1

	
		
		 
		


func _on_collectable_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
