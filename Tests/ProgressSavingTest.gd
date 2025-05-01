extends GutTest


func test_progress_saving() -> void:
	ProgressManager.load_default_progress()
	ProgressManager.day = 23
	ProgressManager.orders_complete = 64
	ProgressManager.money = 45
	ProgressManager.stock[1].age = 23

	var initial_JSON: Dictionary = ProgressManager.get_progress_json()
	var initial_JSON_txt: String = JSON.stringify(initial_JSON)

	ProgressManager.load_default_progress()
	assert_eq(ProgressManager.day, 1)
	
	ProgressManager.read_progress_json(JSON.parse_string(initial_JSON_txt))

	var new_JSON: Dictionary = ProgressManager.get_progress_json()
	var new_JSON_txt: String = JSON.stringify(new_JSON)

	assert_eq(initial_JSON_txt, new_JSON_txt)
