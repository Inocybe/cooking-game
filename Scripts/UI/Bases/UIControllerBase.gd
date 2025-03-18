class_name UIControllerBase extends Node3D


@onready var main_control: Control = %MainControl

@onready var subviewport: SubViewport = $SubViewport

@onready var mesh: MeshInstance3D = $MeshDisplay

@export var press_duration: float = 0.1
@export var press_button = MOUSE_BUTTON_LEFT


func _ready() -> void:
	subviewport.reparent.call_deferred(self)



func world_to_local_space(pos: Vector3) -> Vector2:
	var local_3d_pos: Vector3 = mesh.get_global_transform().affine_inverse() * pos
		
	#if !is_zero_approx(local_3d_pos.z):
	#	print("event not on ui plane")
	#	return Vector2.ZERO
	
	var texture_position: Vector2 = Vector2(local_3d_pos.x, -local_3d_pos.y) / mesh.scale.x  # Assuming uniform scaling
	
	return Vector2(
		texture_position.x * subviewport.size.x,
		texture_position.y * subviewport.size.y
	)


func do_interact_at(pos: Vector3) -> void:
	var local_pos: Vector2 = world_to_local_space(pos)
	print(local_pos)
	
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
