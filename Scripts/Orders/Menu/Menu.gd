extends Node
class_name Menu

enum Item {
	HamBurger = 0,
	Fries,
	Soda,
	Unknown
}

enum FoodComponents {
	Bun = 0,
	Burger,
	Fries,
	Cup
}

const food_root: String = "res://Scenes/Food/"

const MENU_SCENES: Dictionary = {
	Item.HamBurger: [food_root+"bun.tscn", food_root+"burger.tscn"],
	Item.Fries: [food_root+"fries.tscn"],
	Item.Soda: [food_root+"cup.tscn"]
}
