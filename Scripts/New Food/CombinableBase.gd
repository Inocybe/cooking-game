class_name CombinableBase extends Holdable


var recently_removed_child: Array[Node3D] = []


func set_collider_and_state(child: Holdable, disable: bool) -> void:
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


func remove_all_objects_in_array(childed_objects: Array) -> void:
	for child in childed_objects:
		child.reparent(Global.current_scene)
		object_removed(child)
		child.freeze = false
		set_collider_and_state(child, false)


func object_removed(object: Node3D) -> void:
	recently_removed_child.append(object)
