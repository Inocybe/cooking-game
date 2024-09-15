class_name OrderFunctions

var items : Array[Menu.Item]

func create_random_order() -> void:
	var order_size = randi_range(1,5)
	for n in range(order_size):
		items.append(create_random_item())

func create_random_item() -> Menu.Item:
	return randi_range(0,Menu.Item.Soda)

func print_order_items() -> void:
	for item_id in items:
		match item_id:
			Menu.Item.CheeseBurger:
				print("CheeseBurger")
			Menu.Item.HamBurger:
				print("HamBurger")
			Menu.Item.Fries:
				print("Fries")
			Menu.Item.Soda:
				print("Soda")
