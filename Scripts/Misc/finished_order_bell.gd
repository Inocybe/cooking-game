extends Node3D



func on_start_interact() -> void:
	Global.game_manager.food_truck.remove_completed_orders()
