extends Node3D

@onready var money: Label = $Sprite3D/SubViewportContainer/SubViewport/Control/HBoxContainer/Middle/VBoxContainer/Money
@onready var orders_complete: Label = $Sprite3D/SubViewportContainer/SubViewport/Control/HBoxContainer/Middle/VBoxContainer/OrdersComplete


func change_money(current_money: float) -> void:
	if money:
		money.set_text(str(current_money))


func change_order_complete_count(current_orders_complete: int) -> void:
	if orders_complete:
		orders_complete.set_text(str(current_orders_complete))
