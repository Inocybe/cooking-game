class_name OrderManager extends Node


const DISH = preload("res://Scenes/orders/dish.tscn")

var active_orders: Array[Dish] = []


signal order_requested()

signal called_customers_back()

signal review_added(score: float, review: String)


func _ready() -> void:
	get_tree().process_frame.connect(make_customer_order, CONNECT_ONE_SHOT)


func create_random_order() -> Array[Menu.Item]:
	var weather_type = Global.game_manager.weather_manager.weather_type

	var order_size: int = randi_range(
		WeatherManager.get_min_order_size(weather_type), 
		WeatherManager.get_max_order_size(weather_type)
	)

	var items: Array[Menu.Item] = []
	while items.size() < order_size:
		var item: Menu.Item = Utils.weighted_random_val(
			WeatherManager.get_item_weighting(weather_type)
		)
		
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
	dish.queue_free()
	active_orders.erase(dish)


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
	order_requested.emit()
	add_order(customer)
	#customer.finished_ordering()


func call_customers_back() -> void:
	called_customers_back.emit()
	for order in active_orders:
		# Checking if order complete, then goes to food truck and calls the check dish in 
		if order.is_order_complete():
			order.customer_who_gave_me.move_to_pickup()


func make_customer_order() -> void:
	var customer_manager = Global.game_manager.customer_manager
	var customer: Node3D = customer_manager.customers.pick_random()
	if customer.can_order():
		customer.go_to_order()


func register_completed_dish(dish: Dish) -> void:
	var base_worth: float = calculate_worth(dish)
	var order_quality: float = dish.get_order_quality()
	var difficulty_multiplier: float = get_difficulty_multiplier()
	var worth: float = base_worth * order_quality * difficulty_multiplier
	
	Global.game_manager.revenue += worth
	Global.game_manager.served_today += 1
	
	generate_review(dish, order_quality)


func get_review_summary(quality: float) -> String:
	var options: Array[String]
	if quality < 0.3:
		options = ["Food was bad", "Would not recommend", "DO NOT EAT HERE"]
	elif quality < 0.5:
		options = ["Food was OK", "It's alright", "So-so food"]
	elif quality < 0.8:
		options = ["Great food", "Would recommend", "Definitely worth stopping by"]
	else:
		options = ["Superb food!", "Best food in the area!"]
	return options.pick_random()


func generate_review(dish: Dish, order_quality: float):
	var line1: String = get_review_summary(order_quality)
	var line2: String = dish.get_quality_explanations().pick_random()
	review_added.emit(order_quality, line1 + "\n" + line2)


func calculate_worth(dish: Dish) -> float:
	var worth: float = 0
	for item: Menu.Item in dish.order:
		worth += Menu.get_item_retail_price(item)
	return worth


func get_difficulty_multiplier() -> float:
	return {
		0: 1.5,
		1: 1,
		2: 0.8
	}[SettingsManager.difficulty]
