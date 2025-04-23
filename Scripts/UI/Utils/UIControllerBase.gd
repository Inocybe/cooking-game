class_name UIControllerBase extends Node3D


@export var subviewport: SubViewport

@onready var sprite_3d: Sprite3D = $Sprite3D

@export var press_duration: float = 0.1
@export var press_button = MOUSE_BUTTON_LEFT


func world_to_local_space(pos: Vector3) -> Vector2:
	var local_3d_pos = sprite_3d.get_global_transform().affine_inverse() * pos
	
	# Assuming uniform scaling
	var texture_position: Vector2 = Vector2(
		local_3d_pos.x, -local_3d_pos.y
	) / sprite_3d.pixel_size - sprite_3d.get_item_rect().position
	
	return texture_position


func do_interact_at(pos: Vector3) -> void:
	var local_pos: Vector2 = world_to_local_space(pos)
	
	var event_down = InputEventMouseButton.new()
	event_down.pressed = true
	event_down.button_index = press_button
	event_down.position = local_pos
	subviewport.push_input(event_down)
	
	await get_tree().create_timer(press_duration).timeout
	
	var event_up = InputEventMouseButton.new()
	event_up.pressed = false
	event_up.button_index = press_button
	event_up.position = local_pos
	subviewport.push_input(event_up)
