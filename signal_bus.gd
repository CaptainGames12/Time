extends Node
signal player_bought_item(price: int)
signal game_over
signal health_changed(diff: float, type_of_value: String)
signal stamina_changed(diff: float, type_of_value: String)
signal enemy_health_changed(diff: float, enemy: CharacterBody2D)
signal progress_saved()
signal coin_collected(amount: int)
signal entered_the_shop
signal exited_the_shop
signal need_shop_closed
signal need_shop_opened
signal boss_entered(interface: Node)
