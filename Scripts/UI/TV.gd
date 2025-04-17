extends UIControllerBase


@onready var main_control: MainControl = %MainControl


func _process(_delta: float) -> void:
	main_control.orders_complete.set_text(
		str(Global.game_manager.orders_complete)
	)
	
	main_control.money.set_text(
		format_money(Global.game_manager.money)
	)
	
	main_control.time_remaining.set_text(
		format_time(Global.game_manager.time_remaining)
	)


func format_money(money: float) -> String:
	return "$%.2f" % money


func format_time(time: float) -> String:
	return "%d:%02d" % [time / 60, fmod(time, 60)]
