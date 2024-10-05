class_name OrderManager extends Node


const DISH = preload("res://Scenes/orders/dish.tscn")

var order: OrderFunctions = null

var dishes_in_scene: Array[Node3D]
var order_array: Array[OrderFunctions]




func _process(delta: float) -> void:
	pass
	
func new_order() -> void:
	order = OrderFunctions.new()
	order.create_random_order()
	order_array.append(order)
	
	# add dish to scene
	var dish: Node3D = DISH.instantiate()
	dish.order = order.items
	get_tree().current_scene.add_child(dish)
	dish.global_position = Vector3(-2, 2, 0)
	

func clear_orders() -> void:
	order_array.clear()
	for i in range(dishes_in_scene.size()):
		dishes_in_scene.remove_at(i)
