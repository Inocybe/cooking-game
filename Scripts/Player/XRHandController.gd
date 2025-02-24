extends XRController3D


@export var remote_touch_distance: float = 5

@export var grip_cutoff: float = 0.5
@export var trigger_cutoff: float = 0.5

@export var shake_max_time: float = 0.2
@export var shake_required_speed: float = 2

var boundaried_objects: Array[Node3D] = []
var interacted_objects: Array[Node3D] = []
var held_object: Node3D = null

var was_grip: bool = false
var was_trigger: bool = false

var last_position: Vector3
var velocity: Vector3 = Vector3.ZERO

var last_shake_speed_time: float = 0
var last_shake_velocity: Vector3


func is_grip_down() -> bool:
	return get_float("grip") >= grip_cutoff


func is_trigger_down() -> bool:
	return get_float("trigger") >= trigger_cutoff


func on_body_enter_hold_area(body: Node3D) -> void:
	if body == held_object:
		return
	boundaried_objects.append(body)
	if is_grip_down():
		interact_enter(body)


func on_body_exit_hold_area(body: Node3D) -> void:
	if body == held_object:
		return
	boundaried_objects.erase(body)
	if body in interacted_objects:
		interact_exit(body)


func interact_enter(body: Node3D):
	if body.is_in_group("interactable") and not body.is_in_group("holdable"):
		interacted_objects.append(body)
		body.on_start_interact()


func held_enter(body: Node3D):
	if held_object == null and body.is_in_group("holdable") and not body.freeze:
		held_object = body
		var body_transform: Transform3D = body.global_transform
		Global.set_dependance(self, body, true)
		body.global_transform = body_transform
		
		change_hand_positioning(body)



func interact_exit(body: Node3D):
	if body in interacted_objects:
		interacted_objects.erase(body)
		if body.has_method("on_stop_interact"):
			body.on_stop_interact()
		if not $HoldArea.overlaps_body(body):
			on_body_exit_hold_area(body)


func held_exit(body: Node3D):
	if body == held_object:
		held_object = null
		Global.set_dependance(self, body, false)
		body.linear_velocity = velocity
		if not $HoldArea.overlaps_body(body):
			on_body_exit_hold_area(body)
		
		#change_hand_positioning(body)


func forward_vector() -> Vector3:
	return -global_transform.basis.z


func try_remote_interact() -> void:
	var from: Vector3 = global_position
	var to: Vector3 = from + forward_vector() * remote_touch_distance
	var space = get_world_3d().direct_space_state
	var ray_query = PhysicsRayQueryParameters3D.create(from, to)
	var raycast_result: Dictionary = space.intersect_ray(ray_query)
	
	if raycast_result:
		var collider = raycast_result.collider
		if collider.is_in_group("remote-interactable"):
			interact_enter(collider)


func check_food_shake() -> void:
	if velocity.length_squared() > shake_required_speed:
		var now: float = Time.get_unix_time_from_system()
		
		var move_not_expired: bool = last_shake_speed_time + shake_max_time > now
		var has_reversed = velocity.dot(last_shake_velocity) < 0
		var holding_combinable = held_object != null and held_object is CombinableBase
		if move_not_expired and has_reversed and holding_combinable:
			held_object.unparent_all_children()
		
		last_shake_speed_time = now
		last_shake_velocity = velocity


func change_hand_positioning(object: Node3D) -> void:
	var is_left_hand = name.begins_with("Left") # Checking what hand is being used
	if visible:
		if is_left_hand:
			#object.get_node()
			pass
	else:
		pass
	

func _process(delta: float) -> void:
	velocity = (global_position - last_position) / delta
	last_position = global_position
	
	var is_trigger: bool = is_trigger_down()
	if is_trigger and not was_trigger:
		for object: Node3D in boundaried_objects:
			held_enter(object)
	elif not is_trigger and was_trigger:
		if held_object != null:
			held_exit(held_object)
	was_trigger = is_trigger
	
	var is_grip: bool = is_grip_down() and not is_trigger
	if is_grip and not was_grip:
		for object: Node3D in boundaried_objects:
			interact_enter(object)
		try_remote_interact()
	elif not is_grip and was_grip:
		for object: Node3D in boundaried_objects:
			interact_exit(object)
	was_grip = is_grip
	
	if held_object != null and held_object.get_parent() != self:
		held_object = null
	
	for boundaried_object in boundaried_objects:
		if boundaried_object.get_parent() is CombinableBase:
			boundaried_objects.erase(boundaried_object)
	
	check_food_shake()
