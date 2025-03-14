class_name OrderManager extends Node


const DISH = preload("res://Scenes/orders/dish.tscn")

var active_orders: Array[Dish] = []

const MAX_ORDER_SIZE: int = 3
const MIN_ORDER_SIZE: int = 1

#############

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
	dish.get_parent().remove_child.call_deferred(dish)
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
		# Checking if order complete, then goes to food truck and calls the check dish in 
		if order.is_order_complete():
			order.customer_who_gave_me.move_to_foodcart()


func make_customer_order() -> void:
	var customer: Node3D = Global.game_manager.customers.pick_random()
	if customer.state in [Customer.CustomerState.IDLING, Customer.CustomerState.RANDOM_MOVING]:
		customer.move_to_foodcart()

##########################

#TODO implement this shit to do right thing
func increase_variables_based_off_food_completed(dish: Node3D) -> void:
	var base_worth: float = calculate_worth(dish)
	var worth: float = base_worth * dish.get_order_quality()
	
	Global.game_manager.money += worth
	Global.game_manager.orders_complete += 1

func calculate_worth(dish: Node3D) -> float:
	var worth: float = 0
	for item: Menu.Item in dish.order:
		worth += Menu.item_price(item)
	return worth
