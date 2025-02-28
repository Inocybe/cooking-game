extends Control

@export var town_buttons: Array[Control]

func _ready() -> void:
	for button in town_buttons:
		button.generate_town_values()
