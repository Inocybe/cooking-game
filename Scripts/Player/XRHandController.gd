extends XRController3D


@export var grip_cutoff = 0.5
@export var trigger_cutoff = 0.5

var boundaried_objects: Array[Node3D] = []
var interacted_objects: Array[Node3D] = []
var held_objects: Array[Node3D] = []

var was_grip: bool = false
var was_trigger: bool = false


func is_grip_down() -> bool:
	return get_float("grip") >= grip_cutoff


func is_trigger_down() -> bool:
	return get_float("trigger") >= trigger_cutoff


func on_body_enter_hold_area(body: Node3D) -> void:
	boundaried_objects.append(body)
	if is_grip_down():
		interact_enter(body)
	if is_trigger_down():
		held_enter(body)


func on_body_exit_hold_area(body: Node3D) -> void:
	boundaried_objects.erase(body)
	if body in interacted_objects:
		interact_exit(body)
	if body in held_objects:
		held_exit(body)


func interact_exit(body: Node3D):
	interacted_objects.erase(body)
	if body.has_method("on_stop_interact"):
		body.on_stop_interact()


func held_exit(body: Node3D):
	held_objects.erase(body)
	Global.set_dependance(self, body, true)


func _process(_delta: float) -> void:
	var is_trigger: bool = is_trigger_down()
	if is_trigger and not was_trigger:
		for object: Node3D in boundaried_objects:
			held_enter(object)
	elif not is_trigger and was_trigger:
		for object: Node3D in boundaried_objects:
			held_exit(object)
	was_trigger = is_trigger
	
	var is_grip: bool = is_trigger_down() and not is_trigger
	if is_grip and not was_grip:
		for object: Node3D in boundaried_objects:
			interact_enter(object)
	elif not is_grip and was_grip:
		for object: Node3D in boundaried_objects:
			interact_exit(object)
	was_grip = is_grip


func interact_enter(body: Node3D):
	if body.is_in_group("interactable") and not body.is_in_group("holdable"):
		interacted_objects.append(body)
		body.on_start_interact()


func held_enter(body: Node3D):
	if body.is_in_group("holdable"):
		Global.set_dependance(self, body, false)
