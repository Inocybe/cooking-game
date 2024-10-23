class_name OrderFunctions extends Node


const MAX_ORDER_SIZE: int = 3
const MIN_ORDER_SIZE: int = 1

var items : Array[Menu.Item]

func create_random_order() -> void:
	var order_size = randi_range(MIN_ORDER_SIZE, MAX_ORDER_SIZE)
	for n in range(order_size):
		var item: int = create_random_item()
		if not items.has(item):
			items.append(item)

func create_random_item() -> Menu.Item:
	return randi_range(0,Menu.Item.Soda)

func print_order_items() -> void:
	for item_id in items:
		match item_id:
			Menu.Item.HamBurger:
				print("HamBurger")
			Menu.Item.Fries:
				print("Fries")
			Menu.Item.Soda:
				print("Soda")

func get_food_item_scenes(item: Menu.Item) -> Array:
	if Menu.MENU_SCENES.has(item):
		return Menu.MENU_SCENES[item]
	else:
		return []
