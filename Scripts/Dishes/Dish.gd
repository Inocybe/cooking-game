extends Holdable
class_name Dish


const FOOD_ITEM = preload("res://Scenes/orders/food_item.tscn")

var order: Array[Menu.Item]

@export var food_positions: Array[Node3D]


func _ready() -> void:
	super()
	
	for i in range(order.size()):
		var food: Node3D = FOOD_ITEM.instantiate()
		food_positions[i].add_child(food)
