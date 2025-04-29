extends Control


func _ready() -> void:
	var viewport = get_viewport()
	if viewport is SubViewport and viewport.get_parent() is TV:
		%ManageProgressRow.queue_free()


func exit_settings() -> void:
	SettingsManager.substantiate_settings()
	visible = false


func open_progress_location() -> void:
	OS.shell_show_in_file_manager(ProjectSettings.globalize_path("user://"))


func reset_progress() -> void:
	ProgressManager.load_default_progress()
	ProgressManager.save_progress()
