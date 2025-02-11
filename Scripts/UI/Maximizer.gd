extends Control


@export var relative_to: Control

@export var apply_to_x: bool = false
@export var apply_to_y: bool = false
@export var x_padding: float = 0
@export var y_padding: float = 0


func _ready() -> void:
	handle_resize()
	relative_to.resized.connect(handle_resize)


func handle_resize() -> void:
	var parent_size: Vector2 = relative_to.size
	if apply_to_x:
		size.x = parent_size.x - x_padding * 2
	if apply_to_y:
		size.y = parent_size.y - y_padding * 2
