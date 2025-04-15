extends Control


func exit_settings() -> void:
	SettingsManager.substantiate_settings()
	visible = false
