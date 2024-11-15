class_name OrderManager extends Node


const DISH = preload("res://Scenes/orders/dish.tscn")

var active_orders: Array[Dish] = []


const MAX_ORDER_SIZE: int = 3
const MIN_ORDER_SIZE: int = 1


func create_random_order() -> Array[Menu.Item]:
	var items: Array[Menu.Item] = []
	var order_size = randi_range(MIN_ORDER_SIZE, MAX_ORDER_SIZE)
	while items.size() < order_size:
		var item: Menu.Item = Menu.Item.values().pick_random()
		if not items.has(item):
			items.append(item)
	return items


func new_order() -> Node3D:
	# add dish to scene
	var dish: Dish = DISH.instantiate()
	dish.order = create_random_order()
	get_tree().current_scene.add_child(dish)
	active_orders.append(dish)
	return dish


func clear_orders() -> void:
	for dish in active_orders:
		dish.get_parent().remove_child(dish)
	active_orders.clear()
