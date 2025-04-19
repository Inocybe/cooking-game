extends UIControllerBase


@onready var tv_control: TVControl = %TVControl


func _process(_delta: float) -> void:
	tv_control.served_today.set_text(
		"%d orders" % Global.game_manager.served_today
	)
	
	tv_control.revenue.set_text(
		format_money(Global.game_manager.revenue)
	)
	
	tv_control.time_remaining.set_text(
		format_time(Global.game_manager.time_remaining)
	)


func format_money(money: float) -> String:
	return "$%.2f" % money


func format_time(time: float) -> String:
	return "%d:%02d" % [time / 60, fmod(time, 60)]
