extends Node3D


func get_customer_orders() -> void:
	for customer in Global.game_manager.customer_manager.customers:
		customer.on_start_interact()
