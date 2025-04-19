class_name FontScaler extends Node


@export var font_scale: float = 2

var target: Control


func _ready():
	target = get_parent()
	update_font_size()
	Global.font_size_changed.connect(update_font_size)


func update_font_size() -> void:
	target.add_theme_font_size_override(
		"font_size", target.get_theme_default_font_size() * font_scale
	)
