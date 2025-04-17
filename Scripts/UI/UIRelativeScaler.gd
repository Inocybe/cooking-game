extends Control


@export var relative_to: Control
@export var relative_size: Vector2


func _ready() -> void:
	do_resize()
	relative_to.resized.connect(do_resize)


func do_resize() -> void:
	custom_minimum_size = relative_to.size * relative_size
