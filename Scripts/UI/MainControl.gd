class_name MainControl extends Control


@onready var money: Label = %MoneyDisplay
@onready var orders_complete: Label = %OrdersCompleteDisplay

@export var font_size: float = 16


func _ready() -> void:
	var our_theme: Theme = ThemeDB.get_project_theme().duplicate()
	
	our_theme.default_font_size = font_size
	
	theme = our_theme
