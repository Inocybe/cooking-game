class_name MainControl extends Control


@onready var money: Label = %MoneyDisplay
@onready var orders_complete: Label = %OrdersCompleteDisplay
@onready var time_remaining: Label = %TimeRemaining

@export var font_size: int = 16


func _ready() -> void:
	var our_theme: Theme = ThemeDB.get_project_theme().duplicate()
	
	our_theme.default_font_size = font_size
	
	theme = our_theme
