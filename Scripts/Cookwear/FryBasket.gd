extends StaticBody3D


@export_range(0, 1) var lerp_speed : float
@export var max_height : float
@export var min_height : float
@export var height_margin : float
@export var sensitivity : float

var held := false
var previous_mouse_position : Vector2
var target_y: float


func _ready() -> void:
	target_y = position.y


func _process(delta: float) -> void:
	if held:
		handle_holding()
	else:
		handle_released()
	
	position.y = Global.frame_lerp(position.y, target_y, lerp_speed, delta)
	position.y = clamp(position.y, min_height - height_margin, max_height + height_margin)


func on_interact() -> void:
	previous_mouse_position = get_viewport().get_mouse_position()
	held = true


func on_stop_interact() -> void:
	held = false


func handle_holding() -> void:
	var mouse_position : Vector2 = get_viewport().get_mouse_position()
	var delta_y : float = previous_mouse_position.y - mouse_position.y
	target_y += delta_y * sensitivity
	previous_mouse_position = mouse_position


func handle_released() -> void:
	if (position.y - min_height) > (max_height - position.y):
		target_y = max_height
	else:
		target_y = min_height
