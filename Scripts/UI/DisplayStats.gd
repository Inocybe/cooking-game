extends Control


@onready var money_display: Label = %MoneyDisplay
@onready var orders_complete_display: Label = %OrdersDisplay


func _ready() -> void:
	display()
	ProgressManager.progress_saved.connect(display)


func display() -> void:
	money_display.text = Utils.format_money(ProgressManager.money)
	orders_complete_display.text = str(ProgressManager.orders_complete)


func remove_switch_scene() -> void:
	%SwitchSceneButton.queue_free()
	%SwitchSceneSpacer.queue_free()
