extends Control

const STORE_AND_MAP: String = ("res://Scenes/mains/map_menu.tscn")

func start_pressed() -> void:
	Global.switch_scenes_with_path(STORE_AND_MAP)

func quit_pressed() -> void:
	get_tree().quit(0)
