extends HBoxContainer

@onready var chart: ColorRect = $Chart
@onready var label: Label = $FoodLable/Label

const CHART_SCALE_MULTIPLIER: int = 25


func set_food_label(name: String) -> void:
	label.text = name

func set_chart_length_and_text(amount: int) -> void:
	set_chart_label_text(amount)
	set_chart_length(amount)

func set_chart_label_text(amount: int) -> void:
	chart.get_child(0).text = str(amount)

func set_chart_length(amount: int) -> void:
	chart.custom_minimum_size.x = amount * CHART_SCALE_MULTIPLIER
