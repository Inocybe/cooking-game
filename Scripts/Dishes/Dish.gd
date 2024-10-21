extends Holdable
class_name Dish

const GHOST_ORDER_CONTROLLER = preload("res://Scenes/orders/ghost_order_controller.tscn")
const FORCE_AMOUNT: float = 0.005

@export var food_positions: Array[Node3D]

var order: Array[Menu.Item]
var order_functions: OrderFunctions
var childed_objects: Array[Array] = [[], [], []]
var childed_ghosts: Array[Array] = [[], [], []]
var recently_removed_child: Array[Holdable] = []


func _ready() -> void:
	super()
	# Instantiate each item in the order
	for i in range(order.size()):
		for scene in order_functions.get_food_item_scenes(order[i]):
			var food = instantiate_scene_from_path(scene) as Node3D
			if food:
				childed_ghosts[i].append(food)
				combine_objects(food, i)
				add_ghost_order_controller(food)


func instantiate_scene_from_path(scene_path: String) -> Node:
	var scene = load(scene_path)
	var instance = scene.instantiate()
	return instance


func combine_objects(child: Holdable, food_position: int) -> void:
	var parent = food_positions[food_position]
	if not parent.has_node(child.get_path()):
		parent.add_child(child)
	_set_collider_and_state(child, true)
	child.global_transform = parent.global_transform


func add_ghost_order_controller(object: Node3D) -> void:
	var ghost_order_controller = GHOST_ORDER_CONTROLLER.instantiate()
	object.add_child(ghost_order_controller)


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("food") and not childed_objects.has(body) and not recently_removed_child.has(body):
		if body.has_method("get_food_type"):
			check_order_and_add_object(body)


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body in recently_removed_child:
		recently_removed_child.erase(body)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("remove_children") and childed_objects.size() > 0:
		remove_all_objects()


func check_order_and_add_object(body: Node3D) -> void:
	for i in range(childed_ghosts.size()):
		if childed_objects[i].size() == 0:
			for ghost in childed_ghosts[i]:
				if ghost.get_food_type() == body.get_food_type():
					combine_objects(body, i)
					childed_objects[i].append(body)
					disable_ghost_object(i)
					break


func disable_ghost_object(index: int) -> void:
	for ghost in childed_ghosts[index]:
		ghost.visible = false


func enable_ghost_objects() -> void:
	for ghosts in childed_ghosts:
		for ghost in ghosts:
			ghost.visible = true


func remove_all_objects() -> void:
	for objects in childed_objects:
		for child in objects:
			child.reparent(Global.current_scene)
			object_removed(child)
			child.freeze = false
			apply_impulse(Vector3(), Vector3(randf_range(-1, 1), randf_range(-1, 1), randf_range(-1, 1)).normalized() * FORCE_AMOUNT)
			_set_collider_and_state(child, false)
	enable_ghost_objects()
	_reset_child_arrays()


func object_removed(object: Node3D) -> void:
	recently_removed_child.append(object)


func _set_collider_and_state(child: Holdable, disable: bool) -> void:
	var collider: CollisionShape3D = child.get_node_or_null("CollisionShape3D")
	if collider:
		collider.disabled = disable
		
	if disable:
		child.collision_layer = 0
		child.collision_mask = 0
		child.freeze = true
	else:
		child.collision_layer = 1
		child.collision_mask = 1
		child.freeze = false


func _reset_child_arrays() -> void:
	for objects in childed_objects:
		objects.clear()
