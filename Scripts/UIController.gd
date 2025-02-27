class_name UIController extends Node3D


@onready var main_control: Control = %MainControl

@onready var subviewport: SubViewport = $SubViewportContainer/SubViewport

@onready var mesh: MeshInstance3D = $MeshInstance3D

@export var press_duration: float = 0.1
@export var press_button = MOUSE_BUTTON_LEFT


func _ready() -> void:
	subviewport.reparent.call_deferred(self)


func change_money(current_money: float) -> void:
	main_control.money.set_text(str(current_money))


func change_order_complete_count(current_orders_complete: int) -> void:
	main_control.orders_complete.set_text(str(current_orders_complete))


func world_to_local_space(pos: Vector3) -> Vector2:
	var local_3d_pos: Vector3 = mesh.global_transform.affine_inverse() * pos
	var local_3d_size: Vector3 = mesh.mesh.get_aabb().size
	var local_2d_pos = Vector2(
		(local_3d_pos.x / local_3d_size.x) + 0.5,
		0.5 - (local_3d_pos.y / local_3d_size.y)
	)
	return Vector2(
		local_2d_pos.x * subviewport.size.x,
		local_2d_pos.y * subviewport.size.y
	)


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
	event_up.position = Vector2(0, 0)
	subviewport.push_input(event_up)
