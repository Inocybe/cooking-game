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


class ItemComposition:
	var base: FoodComponent
	var children: Array[ItemComposition]
	
	func _init(base_: FoodComponent, children_: Array[ItemComposition] = []) -> void:
		self.base = base_
		self.children = children_
	
	func make() -> Node3D:
		var base_node: Node3D = Menu.make_food_component_scene(self.base)
		for child in children:
			base_node.add_as_child(child.make())
		return base_node
	
	func matches(other: Node3D) -> bool:
		if other.get_food_component_type() != self.base:
			return false
		for i in range(children.size()):
			var other_child: Node3D = other.get_slot_occupant(i)
			if not other_child:
				return false
			if not children[i].matches(other_child):
				return false
		return true


static var item_compositions: Dictionary = {
	Item.HamBurger: ItemComposition.new(
		FoodComponent.Bun, 
		[ItemComposition.new(FoodComponent.Burger)]
	),
	Item.Fries: ItemComposition.new(FoodComponent.Fries),
	Item.Soda: ItemComposition.new(FoodComponent.Cup),
}


static var food_component_scene_paths: Dictionary = {
	FoodComponent.Bun: "res://Scenes/orders/food/bun.tscn",
	FoodComponent.Burger: "res://Scenes/orders/food/burger.tscn",
	FoodComponent.Fries: "res://Scenes/orders/food/fries.tscn",
	FoodComponent.Cup: "res://Scenes/orders/food/cup/cup.tscn"
}


static func get_item_composition(item: Item) -> ItemComposition:
	return item_compositions[item]


static func get_food_component_scene_path(component: FoodComponent) -> String:
	return food_component_scene_paths[component]


static func make_food_component_scene(component: FoodComponent) -> Node3D:
	return load(
		get_food_component_scene_path(component)
	).instantiate() as Node3D


static func compatible_components(component: FoodComponent) -> Array[FoodComponent]:
	match component:
		FoodComponent.Bun:
			return [FoodComponent.Burger]
	return []

static func item_price(item: Item) -> float:
	return {
		Item.HamBurger: 16,
		Item.Fries: 8,
		Item.Soda: 6
	} [item]
