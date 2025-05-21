extends TouchScreenButton
@export var element: Resource
@export var display: Sprite2D
@onready var timer: Timer = $Timer
var collectable = preload("res://shopping/collectable.tscn")
func _ready() -> void:
	
	pressed.connect(timer.start)
	released.connect(timer.stop)
	timer.connect("timeout", drop)

func update(slot: InvSlot)->void:
	
	print(display.name)
	if slot.item:
	
		display.texture = slot.item.small_texture
		display.scale=Vector2(2.4, 2.4)
	
		display.position = Vector2(3, 2)
		display.visible = true
		
func drop():
	
	var counter = 0
	var items = get_parent().itemsList
	for i in items.slots:
		if i.item==element:
			items.slots[counter].item=null
		counter+=1
	physical_drop()
	display.texture=null	
	element=null

func physical_drop():
	var collect_inst = collectable.instantiate()
	collect_inst.item=element
	var player = get_tree().root.get_node("/root/Node2D/Player")
	get_node("/root/Node2D").add_child(collect_inst)
	collect_inst.dropped=true
	collect_inst.position= player.last_facing_dir*70+player.position
