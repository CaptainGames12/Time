extends Camera2D
@export_group("Exited shop")
@export var level_bottom=1080
@export var level_top = 0
@export var level_left=0
@export var level_right=1920
@export_group("Entered shop")
@export var shop_bottom=1080
@export var shop_top = 0
@export var shop_left=0
@export var shop_right=1920
func _ready() -> void:
	SignalBus.entered_the_shop.connect(entered_shop)
	SignalBus.exited_the_shop.connect(exited_shop)
func exited_shop():
	limit_bottom = level_bottom
	limit_top = level_top
	limit_left = level_left
	limit_right = level_right
func entered_shop():
	limit_top = shop_top
	limit_bottom = shop_bottom
	limit_right = shop_right
	limit_left = shop_left
