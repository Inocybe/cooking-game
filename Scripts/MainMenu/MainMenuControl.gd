extends Control

const STORE_AND_MAP: String = ("res://Scenes/mains/store_and_map.tscn")

func start_pressed() -> void:
	Global.switch_scenes(STORE_AND_MAP)

func quit_pressed() -> void:
	get_tree().quit(0)
