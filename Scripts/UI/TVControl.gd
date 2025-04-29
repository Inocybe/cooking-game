class_name TVControl extends Control


@onready var revenue: Label = %RevenueDisplay
@onready var served_today: Label = %ServedTodayDisplay
@onready var time_remaining: Label = %TimeRemaining

@export var font_size: int = 18


func _ready() -> void:
	var our_theme: Theme = ThemeDB.get_project_theme().duplicate()
	
	our_theme.default_font_size = font_size
	
	theme = our_theme
