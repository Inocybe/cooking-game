extends StaticBody3D


@export_range(0, 1) var lerp_speed : float
@export var max_height : float
@export var height_margin : float
@export var sensitivity : float
 	
var target_y: float = 0
var offset_y: float = 0
var base_y: float

var held := false


func _ready() -> void:
	base_y = position.y


func _process(delta: float) -> void:
	offset_y = Global.frame_lerp(offset_y, target_y, lerp_speed, delta)
	offset_y = clamp(offset_y, -height_margin, max_height + height_margin)
	
	position.y = base_y + offset_y


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		target_y += -event.relative.y * sensitivity


func on_start_interact() -> void:
	held = true


func on_stop_interact() -> void:
	held = false
	if offset_y > max_height/2:
		target_y = max_height
	else:
		target_y = 0
