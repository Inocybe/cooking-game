extends Button


var is_paused = false


func _ready() -> void:
	pressed.connect(on_button_pressed)


func on_button_pressed() -> void:
	is_paused = not is_paused
	get_tree().paused = is_paused
	text = "Unpause" if is_paused else "Pause"
