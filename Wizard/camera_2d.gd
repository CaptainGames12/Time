extends Camera2D
func _ready() -> void:
	get_parent().get_parent().in_the_shop.connect(entered_shop)
	get_parent().get_parent().out_of_the_shop.connect(exited_shop)
func exited_shop():
	limit_bottom=1080
	limit_top = 0
	limit_left=0
	limit_right=1920
func entered_shop():
	limit_top=-1250
	limit_bottom=-122
	limit_right=1944
	limit_left=0
