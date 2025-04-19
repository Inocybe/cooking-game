extends Control


func exit_settings() -> void:
	SettingsManager.substantiate_settings()
	visible = false


func reset_progress() -> void:
	ProgressManager.load_default_progress()
	ProgressManager.save_progress()
