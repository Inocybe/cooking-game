class_name ButtonGroupSetting extends SettingControl


@export var button_group: ButtonGroup
@export var button_values: Dictionary[BaseButton, Variant]

var value


func _ready() -> void:
	prop_name = "value"
	super()
	button_values.find_key(value).button_pressed = true
	for button in button_group.get_buttons():
		button.pressed.connect(func(): button_pressed(button))


func button_pressed(button: BaseButton) -> void:
	value = button_values[button]
	change_setting()
