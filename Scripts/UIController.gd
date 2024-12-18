extends Node3D

@onready var money: Label = $Sprite3D/SubViewportContainer/SubViewport/Control/Panel/Money
@onready var order_complete_count: Label = $Sprite3D/SubViewportContainer/SubViewport/Control/Panel2/OrderCompleteCount



func change_money(current_money: float) -> void:
	money.set_text("Money: " + str(current_money))


func change_order_complete_count(current_orders_complete: int) -> void:
	order_complete_count.set_text("Orders Complete: " + str(current_orders_complete))
