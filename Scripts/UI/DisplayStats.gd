extends Control


@onready var money_display: Label = $MoneyLabels/MoneyDisplay
@onready var orders_complete_display: Label = $OrderLabels/OrdersDisplay


func _ready() -> void:
	money_display.text = Global.format_money(ProgressManager.money)
	orders_complete_display.text = str(ProgressManager.orders_complete)
