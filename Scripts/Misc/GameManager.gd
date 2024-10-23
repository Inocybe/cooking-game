class_name GameManager extends Node


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	set_process_input(true)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
