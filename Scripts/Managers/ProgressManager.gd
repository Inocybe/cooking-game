extends Node


class StoredFoodComponent:
	var food: Menu.FoodComponent
	
	func _init(food_: Menu.FoodComponent) -> void:
		self.food = food_
	
	func to_json() -> Dictionary:
		return {
			"food": food
		}
	
	static func from_json(json: Dictionary) -> StoredFoodComponent:
		return StoredFoodComponent.new(json["food"])


const PROGRESS_PATH = "user://progress.json"

var stock: Array[StoredFoodComponent] = []
var day: int = 1
var orders_complete: int = 0
var money: float = 0


func _ready() -> void:
	load_progress()


func save_progress() -> void:
	var file = FileAccess.open(PROGRESS_PATH, FileAccess.WRITE)
	file.store_string(JSON.stringify(get_settings_json()))


func load_progress() -> void:
	if not FileAccess.file_exists(PROGRESS_PATH):
		return
	var file = FileAccess.open(PROGRESS_PATH, FileAccess.READ)
	var json: Dictionary = JSON.parse_string(file.get_as_text())
	if json == null:
		return
	read_settings_json(json)


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
