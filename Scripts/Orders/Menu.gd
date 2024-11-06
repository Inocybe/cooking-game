class_name Menu


enum Item {
	HamBurger,
	Fries,
	Soda
}


enum FoodComponent {
	Bun,
	Burger,
	Fries,
	Cup
}


static func get_item_components(item: Item) -> Array[FoodComponent]:
	match item:
		Item.HamBurger:
			return [FoodComponent.Bun, FoodComponent.Burger]
		Item.Fries:
			return [FoodComponent.Fries]
		Item.Soda:
			return [FoodComponent.Cup]
	return []


static func get_food_component_scene_path(component: FoodComponent) -> String:
	match component:
		FoodComponent.Bun:
			return "res://Scenes/Food/bun.tscn"
		FoodComponent.Burger:
			return "res://Scenes/Food/burger.tscn"
		FoodComponent.Fries:
			return "res://Scenes/Food/fries.tscn"
		FoodComponent.Cup:
			return "res://Scenes/Food/cup.tscn"
	return ""


static func make_food_component_scene(component: FoodComponent) -> Node3D:
	return load(
		get_food_component_scene_path(component)
	).instantiate() as Node3D


static func compatible_components(component: FoodComponent) -> Array[FoodComponent]:
	match component:
		FoodComponent.Bun:
			return [FoodComponent.Burger]
	return []
