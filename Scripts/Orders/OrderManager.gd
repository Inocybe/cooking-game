extends Node

const DISH = preload("res://Scenes/orders/dish.tscn")

var dishes_in_scene: Array[Node3D]
var order: OrderFunctions = null


func _process(delta: float) -> void:
	pass
	
func new_order() -> void:
	order = OrderFunctions.new()
	order.create_random_order()
	order.print_order_items()
