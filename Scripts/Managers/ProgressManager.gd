extends Node


class StoredFoodComponent:
	var food: Menu.FoodComponent
	var age: int
	
	func _init(food_: Menu.FoodComponent, age_: int = 0) -> void:
		self.food = food_
		self.age = age_
	
	func to_json() -> Dictionary:
		return {
			"food": food,
			"age": age
		}
	
	static func from_json(json: Dictionary) -> StoredFoodComponent:
		return StoredFoodComponent.new(json["food"], json["age"])


const PROGRESS_PATH = "user://progress.json"

const STARTING_FOOD_AMOUNTS: Dictionary[Menu.FoodComponent, int] = {
	Menu.FoodComponent.Bun: 8,
	Menu.FoodComponent.Burger: 8,
	Menu.FoodComponent.Fries: 8,
	Menu.FoodComponent.Cup: 15
}

const STARTING_MONEY: float = 100

var stock: Array[StoredFoodComponent]
var day: int
var orders_complete: int
var money: float
var rand_seed: int


signal progress_saved()


func _ready() -> void:
	if not load_progress():
		load_default_progress()


func save_progress() -> void:
	var file = FileAccess.open(PROGRESS_PATH, FileAccess.WRITE)
	file.store_string(JSON.stringify(get_progress_json()))
	progress_saved.emit()


func load_progress() -> bool:
	if not FileAccess.file_exists(PROGRESS_PATH):
		return false
	var file = FileAccess.open(PROGRESS_PATH, FileAccess.READ)
	var json: Dictionary = JSON.parse_string(file.get_as_text())
	if json == null:
		return false
	read_progress_json(json)
	return true


func increment_day() -> void:
	day += 1
	for item: StoredFoodComponent in stock:
		item.age += 1
	stock = stock.filter(has_food_item_not_expired)


func has_food_item_not_expired(item: StoredFoodComponent) -> bool:
	return item.age < Menu.get_food_expire_age(item.food)


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


func load_default_progress() -> void:
	stock = []
	for food in STARTING_FOOD_AMOUNTS.keys():
		for _i in range(STARTING_FOOD_AMOUNTS[food]):
			stock.append(StoredFoodComponent.new(food))
	
	day = 1
	orders_complete = 0
	money = STARTING_MONEY
	rand_seed = hash(Time.get_unix_time_from_system())


func get_food_avaiable_count(component: Menu.FoodComponent) -> int:
	var count: int = 0
	for item: StoredFoodComponent in stock:
		if item.food == component:
			count += 1
	return count


func get_food_expiring_today_count(component: Menu.FoodComponent) -> int:
	var count: int = 0
	for item: StoredFoodComponent in stock:
		if (item.food == component 
			and item.age == Menu.get_food_expire_age(component) - 1):
			count += 1
	return count


func get_progress_json() -> Dictionary:
	var stock_json: Array[Dictionary] = []
	for item: StoredFoodComponent in stock:
		stock_json.append(item.to_json())
	return {
		"stock": stock_json,
		"day": day,
		"orders_complete": orders_complete,
		"money": money,
		"rand_seed": rand_seed
	}


func read_progress_json(json: Dictionary) -> void:
	stock = []
	for item_json: Dictionary in json["stock"]:
		stock.append(StoredFoodComponent.from_json(item_json))
	day = json["day"]
	orders_complete = json["orders_complete"]
	money = json["money"]
	rand_seed = json["rand_seed"]
