extends Node3D


func on_start_interact() -> void:
	Global.game_manager.food_truck.call_customers_with_completed_orders()
