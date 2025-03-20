extends Control

const STORE_AND_MAP: String = ("res://Scenes/mains/store_and_map.tscn")

@onready var button_container: VBoxContainer = $"MAIN/MarginContainer/VBoxContainer/BUTTON CONTAINER"

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
	get_tree().change_scene_to_file(STORE_AND_MAP)

func settings_pressed() -> void:
	print("settings clicked")

func quit_pressed() -> void:
	get_tree().quit(0)
