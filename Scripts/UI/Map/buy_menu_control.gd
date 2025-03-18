extends Control

@onready var food_stock: TextureRect = $MarginContainer/HBoxContainer/FoodStock

var stock_children: Array[Node]

func _ready() -> void:
	stock_children = food_stock.get_children()


func update_stock_children() -> void:
	for child:Node in stock_children:
		if child.has_method("set_food_label"):
			child.set_food_label("")
		if child.has_method("set_chart_length_and_text"):
			child.set_chart_length_and_text(2)
