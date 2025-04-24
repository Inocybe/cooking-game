extends Control


func _ready() -> void:
	var viewport = get_viewport()
	if viewport is SubViewport and viewport.get_parent() is TV:
		%ResetProgressRow.queue_free()


func exit_settings() -> void:
	SettingsManager.substantiate_settings()
	visible = false


func reset_progress() -> void:
	ProgressManager.load_default_progress()
	ProgressManager.save_progress()
