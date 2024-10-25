class_name OrderFunctions


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
	return Menu.Item.values().pick_random()
