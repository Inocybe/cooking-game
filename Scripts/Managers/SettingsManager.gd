extends Node


var overall_volume: float = 1
var music_volume: float = 1


func _ready() -> void:
	settings_updated.connect(do_volume_updates)
	# load settings here
	settings_updated.emit()


func substantiate_settings() -> void:
	# save settings here
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


func get_settings_json() -> Dictionary:
	return {
		"overall_volume": overall_volume,
		"music_volume": music_volume
	}


func read_settings_json(json: Dictionary) -> void:
	overall_volume = json["overall_volume"]
	music_volume = json["music_volume"]


signal settings_updated()
