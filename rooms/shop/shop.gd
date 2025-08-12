extends Node2D
@onready var player: Player = $"../Player"

@onready var shop_theme: AudioStreamPlayer = $AudioStreamPlayer2D

@onready var any_main: Marker2D = $"../Entrances/any"
@onready var any_main_pos = any_main.global_position

@onready var any: Marker2D = $Entrances/any
@onready var entrance_pos = any.global_position

@onready var shop_list = [$Collectable3, $Collectable2, $Collectable, $Collectable4]
func _ready():
	var count = 0
	for i in Global.collected_items:
		count = 0
		for j in shop_list:
			if i==j.item_name:
				shop_list[count].queue_free()
				shop_list.remove_at(count)
			count+=1
