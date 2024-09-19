extends Node

const DISH = preload("res://Scenes/orders/dish.tscn")

func _ready() -> void:
	var order = OrderFunctions.new()
	order.create_random_order()
	order.print_order_items()

func _process(delta: float) -> void:
	pass
