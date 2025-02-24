extends Node3D


@onready var main_control: Control = %MainControl

func change_money(current_money: float) -> void:
	main_control.money.set_text(str(current_money))


func change_order_complete_count(current_orders_complete: int) -> void:
	main_control.orders_complete.set_text(str(current_orders_complete))
