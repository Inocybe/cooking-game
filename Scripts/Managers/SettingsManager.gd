extends Node


const SETTINGS_PATH = "user://settings.json"

var overall_volume: float = 1
var music_volume: float = 1
var mouse_sensitivity: float = 4

enum VRMoveMode {
	CHAIR, WALK
}

var vr_move_mode: VRMoveMode = VRMoveMode.CHAIR


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
	file.store_string(JSON.stringify(get_settings_json()))


func load_settings() -> void:
	if not FileAccess.file_exists(SETTINGS_PATH):
		return
	var file = FileAccess.open(SETTINGS_PATH, FileAccess.READ)
	var json: Dictionary = JSON.parse_string(file.get_as_text())
	if json == null:
		return
	read_settings_json(json)


func get_settings_json() -> Dictionary:
	return {
		"overall_volume": overall_volume,
		"music_volume": music_volume,
		"mouse_sensitivity": mouse_sensitivity,
		"vr_move_mode": vr_move_mode
	}


func read_settings_json(json: Dictionary) -> void:
	overall_volume = json["overall_volume"]
	music_volume = json["music_volume"]
	mouse_sensitivity = json["mouse_sensitivity"]
	vr_move_mode = json["vr_move_mode"]
