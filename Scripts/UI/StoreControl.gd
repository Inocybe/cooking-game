class_name StoreControl extends Control


const RECOMMENDED_FOOD_AMOUNTS: Dictionary[Menu.FoodComponent, int] = {
	Menu.FoodComponent.Bun: 5,
	Menu.FoodComponent.Burger: 5,
	Menu.FoodComponent.Fries: 5,
	Menu.FoodComponent.Cup: 5
}


static func has_recommended_food_amounts() -> bool:
	for food in RECOMMENDED_FOOD_AMOUNTS.keys():
		var amount_now = ProgressManager.get_food_avaiable_count(food)
		var amount_recommended = RECOMMENDED_FOOD_AMOUNTS[food]
		if amount_now < amount_recommended:
			return false
	return true
