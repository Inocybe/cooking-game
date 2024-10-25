class_name Menu


enum Item {
	HamBurger,
	Fries,
	Soda
}


enum FoodComponents {
	Bun,
	Burger,
	Fries,
	Cup
}


static func get_item_components(item: Item) -> Array[FoodComponents]:
	match item:
		Item.HamBurger:
			return [FoodComponents.Bun, FoodComponents.Burger]
		Item.Fries:
			return [FoodComponents.Fries]
		Item.Soda:
			return [FoodComponents.Cup]
	return []


static func get_food_component_scene_path(component: FoodComponents) -> String:
	match component:
		FoodComponents.Bun:
			return "res://Scenes/Food/bun.tscn"
		FoodComponents.Burger:
			return "res://Scenes/Food/burger.tscn"
		FoodComponents.Fries:
			return "res://Scenes/Food/fries.tscn"
		FoodComponents.Cup:
			return "res://Scenes/Food/cup.tscn"
	return ""


static func make_food_component_scene(component: FoodComponents) -> Node3D:
	return load(
		get_food_component_scene_path(component)
	).instantiate() as Node3D
