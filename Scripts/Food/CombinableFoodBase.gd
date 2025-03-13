class_name CombinableFoodBase extends CombinableBase


@export var from_item: Menu.Item
@export var food_component_type: Menu.FoodComponent


func is_compatible_with(other: Node):
	if not super(other):
		return false
	if not other.has_method("get_food_component_type"):
		return false
	var compatible_with = Menu.compatible_components(food_component_type)
	if other.get_food_component_type() not in compatible_with:
		return false
	return true


func get_item_from() -> Menu.Item:
	return from_item


func get_food_component_type() -> Menu.FoodComponent:
	return food_component_type
