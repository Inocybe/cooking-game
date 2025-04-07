extends UIControllerBase


func _process(_delta: float) -> void:
	main_control.orders_complete.set_text(
		str(Global.game_manager.orders_complete)
	)
	
	main_control.money.set_text(
		format_money(Global.game_manager.money)
	)


func format_money(money: float) -> String:
	return "$%.2f" % money
