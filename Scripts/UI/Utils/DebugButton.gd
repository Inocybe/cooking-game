extends Button


func _ready() -> void:
	pressed.connect(on_button_pressed)


func on_button_pressed() -> void:
	print("Button '"+text+"' was pressed")
