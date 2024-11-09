class_name BasicFood extends Holdable


@export var from_item: Menu.Item
@export var food_component_type: Menu.FoodComponent


func get_item_from() -> Menu.Item:
	return from_item


func get_food_component_type() -> Menu.FoodComponent:
	return food_component_type
