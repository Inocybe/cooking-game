extends Control

@onready var button_container: VBoxContainer = $"TextureRect/MarginContainer/VBoxContainer/BUTTON CONTAINER"

var button_dict: Dictionary[String, Callable]

func _ready() -> void:
	for child in button_container.get_children():
		if child is Button:
			child.button_down.connect(button_pressed.bind(child.name))
			button_dict[child.name] = Callable(self, child.name.to_lower() + "_pressed")

func button_pressed(button_id: String) -> void:
	button_dict[button_id].call()
	#Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func start_pressed() -> void:
	print("start clicked")

func settings_pressed() -> void:
	print("settings clicked")

func quit_pressed() -> void:
	get_tree().quit(0)
