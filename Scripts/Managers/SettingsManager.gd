extends Node


const SETTINGS_PATH = "user://settings.json"

var overall_volume: float = 1
var music_volume: float = 1


signal settings_updated()


func _ready() -> void:
	settings_updated.connect(do_volume_updates)
	load_settings()
	settings_updated.emit()


func substantiate_settings() -> void:
	save_settings()
	settings_updated.emit()


func do_volume_updates() -> void:
	AudioServer.set_bus_volume_linear(
		AudioServer.get_bus_index("Master"),
		overall_volume
	)
	
	AudioServer.set_bus_volume_linear(
		AudioServer.get_bus_index("Music"),
		music_volume
	)


func save_settings() -> void:
	var file = FileAccess.open(SETTINGS_PATH, FileAccess.WRITE)
	file.store_string(get_settings_json_txt())


func load_settings() -> void:
	if not FileAccess.file_exists(SETTINGS_PATH):
		return
	var file = FileAccess.open(SETTINGS_PATH, FileAccess.READ)
	read_settings_json_txt(file.get_as_text())


func get_settings_json_txt() -> String:
	return JSON.stringify({
		"overall_volume": overall_volume,
		"music_volume": music_volume
	})


func read_settings_json_txt(json_txt: String) -> void:
	var json: Dictionary = JSON.parse_string(json_txt)
	overall_volume = json["overall_volume"]
	music_volume = json["music_volume"]
