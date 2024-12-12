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


func remove_order(dish: Dish) -> void:
	dish.get_parent().remove_child(dish)
	active_orders.erase(dish)

############

func maybe_invoke_ordering() -> void:
	if randf() < 0.5 ** active_orders.size():
		make_customer_order()

func add_order(customer: Customer) -> void:
	var pos: Node3D = Global.game_manager.food_truck.choose_best_dish_spawnpoint()
	
	var order: Dish = new_order()
	order.global_position = pos.global_position
	order.global_rotation = pos.global_rotation
	order.customer_who_gave_me = customer
	
	customer.dish_ordered = order # setting dish to customer so customer knows what dish they ordered


func request_order_from(customer: Customer):
	add_order(customer)
	#customer.finished_ordering()


func call_customers_with_completed_orders() -> void:
	for order in active_orders:
		# Checking if order complete, then goes to food truck and calls the check dish in area
		if order.is_order_complete():
			order.customer_who_gave_me.move_to_foodcart()


func make_customer_order() -> void:
	var customer: Node3D = Global.game_manager.customers.pick_random()
	customer.move_to_foodcart()
