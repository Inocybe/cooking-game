extends Control


@onready var money_display: Label = %MoneyDisplay
@onready var orders_complete_display: Label = %OrdersDisplay


func _ready() -> void:
	display()
	ProgressManager.progress_saved.connect(display)


func display() -> void:
	money_display.text = Global.format_money(ProgressManager.money)
	orders_complete_display.text = str(ProgressManager.orders_complete)
