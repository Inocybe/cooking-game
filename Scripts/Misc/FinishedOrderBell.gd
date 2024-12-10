extends Node3D


func on_start_interact() -> void:
	Global.order_manager.call_customers_with_completed_orders()
