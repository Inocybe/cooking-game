extends Node


class StoredFoodComponent:
	var food: Menu.FoodComponent
	var age: int
	
	func _init(food_: Menu.FoodComponent, age: int = 0) -> void:
		self.food = food_
		self.age = age
	
	func to_json() -> Dictionary:
		return {
			"food": food,
			"age": age
		}
	
	static func from_json(json: Dictionary) -> StoredFoodComponent:
		return StoredFoodComponent.new(json["food"], json["age"])


const PROGRESS_PATH = "user://progress.json"

const DEFAULT_FOOD_AMOUNTS: Dictionary[Menu.FoodComponent, int] = {
	Menu.FoodComponent.Bun: 5,
	Menu.FoodComponent.Burger: 5,
	Menu.FoodComponent.Fries: 5,
	Menu.FoodComponent.Cup: 5
}

var stock: Array[StoredFoodComponent] = []
var day: int = 1
var orders_complete: int = 0
var money: float = 0


func _ready() -> void:
	if not load_progress():
		load_default_process()


func save_progress() -> void:
	var file = FileAccess.open(PROGRESS_PATH, FileAccess.WRITE)
	file.store_string(JSON.stringify(get_settings_json()))


func load_progress() -> bool:
	if not FileAccess.file_exists(PROGRESS_PATH):
		return false
	var file = FileAccess.open(PROGRESS_PATH, FileAccess.READ)
	var json: Dictionary = JSON.parse_string(file.get_as_text())
	if json == null:
		return false
	read_settings_json(json)
	return true


func increment_day() -> void:
	day += 1
	for item: StoredFoodComponent in stock:
		item.age += 1


func removed_used_food(used: Dictionary[Menu.FoodComponent, int]) -> void:
	used = used.duplicate()
	var i: int = 0
	while i < len(stock):
		var item_food = stock[i].food
		var item_food_used_count = used.get(item_food, 0)
		if item_food_used_count > 0:
			stock.pop_at(i)
			used[item_food] = item_food_used_count - 1
		else:
			i += 1


func load_default_process() -> void:
	stock = []
	for food in DEFAULT_FOOD_AMOUNTS.keys():
		for _i in range(DEFAULT_FOOD_AMOUNTS[food]):
			stock.append(StoredFoodComponent.new(food))
	
	day = 1
	orders_complete = 0
	money = 0


func get_food_avaiable_count(component: Menu.FoodComponent) -> int:
	var count: int = 0
	for item: StoredFoodComponent in stock:
		if item.food == component:
			count += 1
	return count


func get_settings_json() -> Dictionary:
	var stock_json: Array[Dictionary] = []
	for item: StoredFoodComponent in stock:
		stock_json.append(item.to_json())
	return {
		"stock": stock_json,
		"day": day,
		"orders_complete": orders_complete,
		"money": money
	}


func read_settings_json(json: Dictionary) -> void:
	stock = []
	for item_json: Dictionary in json["stock"]:
		stock.append(StoredFoodComponent.from_json(item_json))
	day = json["day"]
	orders_complete = json["orders_complete"]
	money = json["money"]
