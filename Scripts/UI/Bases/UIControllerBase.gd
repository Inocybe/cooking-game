class_name UIControllerBase extends Node3D


@onready var main_control: Control = %MainControl

@onready var subviewport: SubViewport = $SubViewport

@onready var mesh: MeshInstance3D = $MeshDisplay

@onready var sprite_3d: Sprite3D = $Sprite3D

@export var press_duration: float = 0.1
@export var press_button = MOUSE_BUTTON_LEFT


func _ready() -> void:
	subviewport.reparent.call_deferred(self)



func world_to_local_space(pos: Vector3) -> Vector2:
	var local_3d_pos: Vector3 = sprite_3d.get_global_transform().affine_inverse() * pos
		
	#if !is_zero_approx(local_3d_pos.z):
		#print("event not on ui plane")
		#return Vector2.ZERO
	
	var texture_position: Vector2 = Vector2(local_3d_pos.x, -local_3d_pos.y) / sprite_3d.pixel_size - sprite_3d.get_item_rect().position  # Assuming uniform scaling
	
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
