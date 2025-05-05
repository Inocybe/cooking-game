class_name Dish extends CombinableBase


const GHOST_ORDER_CONTROLLER = preload("res://Scenes/orders/ghost_order_controller.tscn")

var order: Array[Menu.Item]
var ghosts: Array[Node3D] = []
var food_slots: Dictionary = Dictionary()

var active_time: float = 0

var customer_who_gave_me: Node3D = null


func _ready() -> void:
	super()
	add_ghosts.call_deferred()


func add_ghosts() -> void:
	for i in range(order.size()):
		ghosts.append(null)
		add_ghost_to_slot(i)


func add_ghost_to_slot(i: int) -> void:
	var ghost = Menu.get_item_composition(order[i]).make()
	ghosts[i] = ghost
	move_to_slot(ghost, i)
	make_item_ghost(ghost)


func _process(delta: float) -> void:
	active_time += delta


func make_item_ghost(obj: Node3D) -> void:
	var ghost_order_controller = GHOST_ORDER_CONTROLLER.instantiate()
	obj.add_child(ghost_order_controller)


func get_collision_y_offset(shape: Shape3D):
	if shape is BoxShape3D:
		var box_shape: BoxShape3D = shape as BoxShape3D
		return box_shape.size.y / 2
	elif shape is CylinderShape3D:
		var cylinder_shape: CylinderShape3D = shape as CylinderShape3D
		return cylinder_shape.get_height() / 2
	elif shape is SphereShape3D:
		var sphere_shape: SphereShape3D = shape as SphereShape3D
		return sphere_shape.radius
	else:
		return 0


func choose_child_slot(food: Node3D) -> int:
	for i in range(order.size()):
		if food_slots.values().has(i):
			continue
		if Menu.get_item_composition(order[i]).matches(food):
			remove_ghost(i)
			food_slots[food] = i
			return i
	return -1


func handle_child_removal(child: Node3D) -> void:
	add_ghost_to_slot(food_slots[child])
	food_slots.erase(child)


func remove_ghost(i: int) -> void:
	var ghost: Node3D = ghosts[i]
	ghost.get_parent().remove_child(ghost)


func offset_added_child(food: Node3D) -> void:
	var collision_shapes = food.find_children("*", "CollisionShape3D", false)
	
	var offset_height: float = 0.0
	
	for collision in collision_shapes:
		var this_collision_height = get_collision_y_offset(collision.shape)
		var this_offset_height = this_collision_height - collision.position.y
		if this_offset_height > offset_height:
			offset_height = this_offset_height
	
	food.position.y += offset_height


func is_order_complete() -> bool:
	return order.size() == food_slots.size()


func get_base_quality() -> float:
	return min(0.5 ** (active_time/30-1), 1)


func get_quality_explanation() -> String:
	if active_time < 45:
		return "Service was prompt"
	elif active_time < 120:
		return "Service was OK"
	else:
		return "Food was very slow"


func get_item_quality(item: Node3D) -> float:
	if item.has_method("get_quality"):
		return item.get_quality()
	var cookable: Cookable = item.get_node_or_null("Cookable")
	if cookable != null:
		return cookable.get_quality()
	return 1


func get_order_quality() -> float:
	if not is_order_complete():
		return 0
	var quality: float = get_base_quality()
	var stack: Array[CombinableBase] = [self]
	while stack.size() > 0:
		for item in stack.pop_back().children:
			quality *= get_item_quality(item)
			if item is CombinableBase:
				stack.append(item)
	return quality


func get_item_quality_explanation(item: Node3D):
	if item.has_method("get_quality_explanation"):
		return item.get_quality_explanation()
	var cookable: Cookable = item.get_node_or_null("Cookable")
	if cookable != null:
		return cookable.get_quality_explanation()
	return null


func get_quality_explanations() -> Array[String]:
	var explanations: Array[String] = []
	var stack: Array[Node3D] = [self]
	
	while stack.size() > 0:
		var item: Node3D = stack.pop_back()
		
		var explanation = get_item_quality_explanation(item)
		if explanation != null:
			explanations.append(explanation)
		
		if item is CombinableBase:
			stack.append_array(item.children)
	
	return explanations
