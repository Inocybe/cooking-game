extends StaticBody3D

var order_manager: OrderManager

func _ready() -> void:
	order_manager = Global.order_manager

func on_start_interact():
	order_manager.new_order()
	
func on_stop_interact():
	pass
