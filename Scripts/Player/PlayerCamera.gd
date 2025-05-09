class_name PlayerCamera extends Camera3D


@export var arm_length: float = 5
@export var min_hold_dist: float = 0.5
@export var max_hold_dist: float = 2.5
@export var hold_dist_sensitivity: float = 0.4

var hovered_object: Node3D = null
var object_hover_point: Vector3

var selected_object: Node3D = null
var held_distance: float

@onready var timer: Timer = %HoldModeTimer


signal picked_up_thing()

signal scroll_moved_thing()


func forward_vector() -> Vector3:
	return -global_transform.basis.z


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		do_interact()
	
	if (event.is_action_released("interact") and selected_object != null
		and timer.is_stopped()):
		drop_if_selected()
	
	var scroll: float = Input.get_axis("scroll_down", "scroll_up")
	if selected_object and not is_zero_approx(scroll):
		scroll_moved_thing.emit()
	held_distance += hold_dist_sensitivity * scroll
	held_distance = clamp(held_distance, min_hold_dist, max_hold_dist)


func _process(_delta: float) -> void:
	var raycast_result: Dictionary = shoot_ray()
	
	if raycast_result:
		hovered_object = raycast_result.collider
		object_hover_point = raycast_result.position
	else:
		hovered_object = null
	
	%Reticle.set_is_interactable(
		hovered_object != null and (
		hovered_object.is_in_group("holdable")
		or hovered_object.is_in_group("interactable")
		or hovered_object.is_in_group("world-ui"))
	)
	
	if selected_object and selected_object.is_in_group("holdable"):
		selected_object.set_held_position(
			global_position + forward_vector() * held_distance,
			global_rotation.y + PI/2
		)


func shoot_ray() -> Dictionary:
	var from: Vector3 = global_position
	var to: Vector3 = from + forward_vector() * arm_length
	var space = get_world_3d().direct_space_state
	var ray_query = PhysicsRayQueryParameters3D.create(from, to)
	return space.intersect_ray(ray_query)


func pick_up(obj: Node) -> void:
	picked_up_thing.emit()
	selected_object = obj.on_start_interact()
	if selected_object == null:
		selected_object = obj
	timer.start()
	if obj.is_in_group("holdable"):
		held_distance = (global_position - obj.global_position).length()


func interact_with(obj: Node) -> void:
	obj.on_start_interact()


func interact_with_ui(obj: Node3D, pos: Vector3):
	obj.do_interact_at(pos)


func drop_selected() -> void:
	if selected_object.has_method("on_stop_interact"):
		selected_object.on_stop_interact()
	selected_object = null


func drop_if_selected() -> void:
	if selected_object != null:
		drop_selected()


func drop_if_specific_selected(obj: Node) -> void:
	if selected_object == obj:
		drop_selected()


func do_interact() -> void:
	if selected_object != null:
		drop_selected()
		return
	
	if hovered_object:
		if hovered_object.is_in_group("holdable"):
			pick_up(hovered_object)
		elif hovered_object.is_in_group("interactable"):
			interact_with(hovered_object)
		elif hovered_object.is_in_group("world-ui"):
			interact_with_ui(hovered_object, object_hover_point)
