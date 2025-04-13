class_name SettingControl extends Node


@export var prop_name: String
@export var setting_name: String


func _ready() -> void:
	set(prop_name, SettingsManager.get(setting_name))


func change_setting(v=null) -> void:
	SettingsManager.set(setting_name, get(prop_name))
