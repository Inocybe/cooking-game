extends Node


class StoredFoodComponent:
	var food: Menu.FoodComponent
	
	func _init(food_: Menu.FoodComponent) -> void:
		self.food = food_


var stock: Array[StoredFoodComponent] = []
var day: int = 1
var orders_complete: int = 0
var money: float = 0
