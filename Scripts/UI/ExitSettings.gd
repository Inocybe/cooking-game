extends Button


@export var settings_root: Control


func exit_settings() -> void:
	SettingsManager.substantiate_settings()
	settings_root.visible = false
