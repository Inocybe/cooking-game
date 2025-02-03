extends Control


@onready var money: Label = $"HBoxContainer/Left/GridContainer/Money Display"
@onready var orders_complete: Label = $"HBoxContainer/Left/GridContainer/Orders Complete Display"


func retrun_money() -> Label:
	return money
func return_order_count() -> Label:
	return orders_complete
