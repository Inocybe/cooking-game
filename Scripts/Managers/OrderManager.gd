class_name OrderManager extends Node


const DISH = preload("res://Scenes/orders/dish.tscn")

var dishes_in_scene: Array[Node3D]


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


func new_order() -> void:
	# add dish to scene
	var dish: Dish = DISH.instantiate()
	dish.order = create_random_order()
	get_tree().current_scene.add_child(dish)
	dish.global_position = Vector3(-4, 2, 0)


func clear_orders() -> void:
	for i in range(dishes_in_scene.size()):
		dishes_in_scene.remove_at(i)
