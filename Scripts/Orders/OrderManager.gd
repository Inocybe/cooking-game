extends Node

const DISH = preload("res://Scenes/orders/dish.tscn")

var order: OrderFunctions = null

var dishes_in_scene: Array[Node3D]
var order_array: Array[OrderFunctions]




func _process(delta: float) -> void:
	pass
	
func new_order() -> void:
	order = OrderFunctions.new()
	order.create_random_order()
	order.print_order_items()
	order_array.append(order)

func clear_orders() -> void:
	order_array.clear()
	for i in range(dishes_in_scene.size()):
		dishes_in_scene.remove_at(i)
