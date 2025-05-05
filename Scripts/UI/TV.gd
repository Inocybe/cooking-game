class_name TV extends UIControllerBase


@onready var tv_control: TVControl = %TVControl


func _ready() -> void:
	Global.game_manager.order_manager.review_added.connect(
		tv_control.set_latest_review
	)


func _process(_delta: float) -> void:
	tv_control.served_today.set_text(
		"%d orders" % Global.game_manager.served_today
	)
	
	tv_control.revenue.set_text(
		Utils.format_money(Global.game_manager.revenue)
	)
	
	tv_control.time_remaining.set_text(
		Utils.format_time(Global.game_manager.time_remaining)
	)
