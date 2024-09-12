extends StaticBody3D

@export var lerp_speed : float
@export var max_height : float
@export var min_height : float
@export var sensitivity : float

var clicked := false
var previous_mouse_position : Vector2


func _ready() -> void:
	add_to_group("interactable")

func _process(delta: float) -> void:
	if clicked:
		handle_holding()
	else:
		handle_release()
		pass

func on_interact() -> void:
	previous_mouse_position = get_viewport().get_mouse_position()
	clicked = true
	
func on_stop_interact() -> void:
	clicked = false


func handle_holding() -> void:
	var mouse_position : Vector2 = get_viewport().get_mouse_position()
	var delta_y : float = -(mouse_position.y - previous_mouse_position.y)
	
	#if min_height < position.y and position.y < max_height:
	position.y = lerp(position.y, position.y + (delta_y * sensitivity), lerp_speed)
		
	
	previous_mouse_position = mouse_position
	
func handle_release() -> void:
	pass
	
	
