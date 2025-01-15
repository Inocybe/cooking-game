extends Control

@onready var money: Label = $HBoxContainer/Middle/VBoxContainer/Money
@onready var orders_complete: Label = $HBoxContainer/Middle/VBoxContainer/OrdersComplete



func retrun_money() -> Label:
	return money
func return_order_count() -> Label:
	return orders_complete
