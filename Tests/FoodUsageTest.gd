extends GutTest


const GAME_MANAGER = preload("res://Scenes/managers/game_manager.tscn")


func test_day_end_food_consumed() -> void:
	ProgressManager.load_default_progress()
	ProgressManager.stock = []
	for i in range(3):
		var item = ProgressManager.StoredFoodComponent.new(Menu.FoodComponent.Bun, 2-i)
		ProgressManager.stock.append(item)
	var game_manager: GameManager = GAME_MANAGER.instantiate()
	assert_true(game_manager.try_use_food(Menu.FoodComponent.Bun))
	assert_true(game_manager.try_use_food(Menu.FoodComponent.Bun))
	game_manager.update_progress_from_day()
	assert_eq(ProgressManager.day, 2)
	assert_eq(len(ProgressManager.stock), 1)
	assert_eq(ProgressManager.stock[0].age, 1) # the age would have been 0, but one day has passed


func test_consumption() -> void:
	ProgressManager.load_default_progress()
	var game_manager: GameManager = GAME_MANAGER.instantiate()
	for component in Menu.FoodComponent.values():
		for i in range(ProgressManager.STARTING_FOOD_AMOUNTS[component]):
			assert_true(game_manager.try_use_food(component))
		assert_false(game_manager.try_use_food(component))


func test_item_expiration() -> void:
	for component in Menu.FoodComponent.values():
		ProgressManager.load_default_progress()
		var initial_food_amount = ProgressManager.get_food_available_count(component)
		for i in range(Menu.get_food_expire_age(component)-1):
			ProgressManager.increment_day()
			assert_eq(ProgressManager.get_food_available_count(component), initial_food_amount)
		var item = ProgressManager.StoredFoodComponent.new(component)
		ProgressManager.stock.append(item)
		ProgressManager.increment_day()
		assert_eq(ProgressManager.get_food_available_count(component), 1)
