extends StaticBody2D
class_name CoinsGenerator

@export var object_scene: PackedScene
var array_coins : Array[Node2D]
var coins : int
@onready var marker_2d: Marker2D = $Marker2D
@onready var label: Label = $Label

func _ready() -> void:
	addMoney(Global.score)
	SignalBus.player_bought_item.connect(removeCoins)
func addMoney(count : int) -> void: 
	coins += count;
	

func getMoney() -> int:
	return array_coins.size()
	
func removeCoins(count : int) -> void:
	for i in range(count):
		if(array_coins.get(0) != null):
			var temp : Node2D = array_coins.get(0)
			temp.queue_free()
			array_coins.remove_at(0)
			label.text = str(array_coins.size())+"$"
func _on_timer_timeout() -> void:

	if(coins > 0) :
		PhysicsServer2D.set_active(true)
		var instance : Node2D = object_scene.instantiate()
		
		instance.position = marker_2d.position
		instance.rotate(randi() % 60)
		add_child(instance)
		instance.scale/=2
		array_coins.append(instance)
		coins -= 1;
		label.text = str(array_coins.size())+"$"
