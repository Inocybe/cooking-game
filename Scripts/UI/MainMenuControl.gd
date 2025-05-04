extends Control


const MAP_MENU: String = "res://Scenes/mains/map_menu.tscn"


func _ready() -> void:
	start_pressed()


func start_pressed() -> void:
	Global.switch_scenes_with_path(MAP_MENU)


func quit_pressed() -> void:
	get_tree().quit(0)
