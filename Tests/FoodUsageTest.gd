extends GutTest


const GAME_MANAGER = preload("res://Scenes/managers/game_manager.tscn")


func test_consumption() -> void:
	ProgressManager.load_default_progress()
	var game_manager: GameManager = GAME_MANAGER.instantiate()
	for component in Menu.FoodComponent.values():
		for i in range(ProgressManager.STARTING_FOOD_AMOUNTS[component]):
			assert_true(game_manager.try_use_food(component))
		assert_false(game_manager.try_use_food(component))
