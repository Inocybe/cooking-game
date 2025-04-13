extends Control


@export var prop_name: String
@export var signal_name: String
@export var setting_name: String


func _ready() -> void:
	set(prop_name, SettingsManager.get(setting_name))
	get(signal_name).connect(value_changed)


func value_changed() -> void:
	SettingsManager.set(setting_name, get(prop_name))
