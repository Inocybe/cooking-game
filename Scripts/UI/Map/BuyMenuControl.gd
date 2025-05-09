extends Control

@export var food_component_chart: Dictionary[Menu.FoodComponent, Control]

func _process(delta: float) -> void:
	food_component_chart[0] = $VBoxContainer/FoodStockChart
	food_component_chart[1] = $VBoxContainer/FoodStockChart2
	food_component_chart[2] = $VBoxContainer/FoodStockChart3
	food_component_chart[3] = $VBoxContainer/FoodStockChart4
	
	update_stock()


func update_stock() -> void:
	for component in Menu.FoodComponent.values():
		update_stock_children(
			food_component_chart[component], component
		)


func update_stock_children(control: Control, component: Menu.FoodComponent) -> void:
	if control:
		if control.has_method("set_food_label"):
			control.set_food_label(Menu.get_food_component_name(component))
		if control.has_method("set_chart_length_and_text"):
			control.set_chart_length_and_text(
				ProgressManager.get_food_available_count(component)
					- Global.game_manager.food_components_used.get(component, 0)
			)
