extends GutTest


const GAME_MANAGER = preload("res://Scenes/managers/game_manager.tscn")


func test_day_end_food_consumed() -> void:
	ProgressManager.load_default_progress()
	ProgressManager.stock = []
	for i in range(len(3)):
		var item = ProgressManager.StoredFoodComponent.new(Menu.FoodComponent.Bun, 3-i)
		ProgressManager.stock.append(item)
	var game_manager: GameManager = GAME_MANAGER.instantiate()
	assert_true(game_manager.try_use_food(Menu.FoodComponent.Bun))
	assert_true(game_manager.try_use_food(Menu.FoodComponent.Bun))
	game_manager.update_progress_from_day()
	assert_equal(ProgressManager.day, 2)
	assert_eq(len(ProgressManager.stock), 1)
	assert_eq(ProgressManager.stock[0].age, 1)


func test_consumption() -> void:
	ProgressManager.load_default_progress()
	var game_manager: GameManager = GAME_MANAGER.instantiate()
	for component in Menu.FoodComponent.values():
		for i in range(ProgressManager.STARTING_FOOD_AMOUNTS[component]):
			assert_true(game_manager.try_use_food(component))
		assert_false(game_manager.try_use_food(component))
