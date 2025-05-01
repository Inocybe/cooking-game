extends XRController3D


@export var remote_touch_distance: float = 10

@export var grip_cutoff: float = 0.7
@export var trigger_cutoff: float = 0.5

var boundaried_objects: Array[Node3D] = []
var interacted_objects: Array[Node3D] = []
var held_object: Node3D = null

var was_grip: bool = false
var was_trigger: bool = false

var last_position: Vector3
var velocity: Vector3 = Vector3.ZERO


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


func interact_with_ui(obj: Node3D, pos: Vector3):
	obj.do_interact_at(pos)


func interact_enter(body: Node3D, pos=null):
	if pos == null:
		pos = global_position
	if body.is_in_group("interactable") and not body.is_in_group("holdable"):
		interacted_objects.append(body)
		body.on_start_interact()
	elif body.is_in_group("world-ui"):
		interact_with_ui(body, pos)
	


func held_enter(body: Node3D):
	if held_object == null and body.is_in_group("holdable") and not body.freeze:
		Global.xr_manager.grabbed_thing.emit()
		
		held_object = body
		Global.set_dependance(self, body, true)
		
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
	var dist = remote_touch_distance
	
	var from: Vector3 = global_position
	var to: Vector3 = from + forward_vector() * dist
	var space = get_world_3d().direct_space_state
	var ray_query = PhysicsRayQueryParameters3D.create(from, to)
	var raycast_result: Dictionary = space.intersect_ray(ray_query)
	
	if raycast_result:
		var collider = raycast_result.collider
		if collider.is_in_group("remote-interactable"):
			interact_enter(collider, raycast_result.position)


func change_hand_positioning(_object: Node3D) -> void:
	#var is_left_hand = name.begins_with("Left") # Checking what hand is being used
	#if visible:
		#if is_left_hand:
			#object.get_node()
			#pass
	#else:
		#pass
	pass


func remove_invalid_boundaried() -> void:
	var new_boundaried: Array[Node3D] = []
	for boundaried_object in boundaried_objects:
		if (is_instance_valid(boundaried_object)
			and not boundaried_object.get_parent() is CombinableBase):
			new_boundaried.append(boundaried_object)
	boundaried_objects = new_boundaried


func remove_invalid_held() -> void:
	if not is_instance_valid(held_object):
		held_object = null


func _process(delta: float) -> void:
	velocity = (global_position - last_position) / delta
	last_position = global_position
	
	remove_invalid_boundaried()
	remove_invalid_held()
	
	var is_trigger: bool = is_trigger_down()
	if is_trigger and not was_trigger:
		for object: Node3D in boundaried_objects:
			held_enter(object)
		if Global.game_state == Global.GameState.MENU:
			try_remote_interact()
	elif not is_trigger and was_trigger:
		if held_object != null:
			held_exit(held_object)
	was_trigger = is_trigger
	
	var is_grip: bool = is_grip_down() and not is_trigger
	if is_grip and not was_grip:
		Global.xr_manager.pointed.emit()
		for object: Node3D in boundaried_objects:
			interact_enter(object)
		try_remote_interact()
	elif not is_grip and was_grip:
		for object: Node3D in boundaried_objects:
			interact_exit(object)
	was_grip = is_grip
	
	if held_object != null and held_object.get_parent() != self:
		held_object = null
