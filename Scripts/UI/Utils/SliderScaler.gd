extends Node


@export var stylebox: StyleBoxFlat
@export var height_fraction: float = 0.25
@export var width_ratio: float = 80

var relative_to: Control
var slider: Slider


func _ready() -> void:
	slider = get_parent()
	relative_to = slider.get_parent()
	do_resize()
	relative_to.resized.connect(do_resize)


func do_resize() -> void:
	var height: float = relative_to.size.y * height_fraction
	stylebox.content_margin_top = height
	slider.add_theme_stylebox_override("slider", stylebox)
	slider.custom_minimum_size.x = width_ratio * height
