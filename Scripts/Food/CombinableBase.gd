class_name CombinableBase extends Holdable


@export var combine_range: Area3D = null
@export var hold_positions: Array[Node3D] = []

var children: Array[Node3D] = []
var children_being_removed: Array[Node3D] = []
var removed_children: Array[Node3D] = []


func _ready() -> void:
	super()
	# Connect combine range signals if present
	if combine_range:
		combine_range.connect("body_entered", _on_body_entered)
		combine_range.connect("body_exited", _on_body_exited)


func is_compatible_with(other: Node):
	return other.is_in_group("food") and other != self


func _on_body_entered(body: Node) -> void:
	if body.get_parent() and body.get_parent() is CombinableBase:
		return
	if removed_children.has(body) or children_being_removed.has(body):
		return
	if not is_compatible_with(body):
		return
	add_as_child(body as Holdable)


func unparent_child(child: Node3D) -> void:
	children.erase(child)
	children_being_removed.append(child)
	await get_tree().process_frame
	Global.set_dependance(self, child, false)
	handle_child_removal(child)
	await get_tree().process_frame
	children_being_removed.erase(child)
	removed_children.append(child)


func handle_child_removal(_child: Node3D) -> void:
	pass


func unparent_all_children() -> void:
	for child in children:
		unparent_child(child)


func add_as_child(child: Holdable) -> void:
	if children.has(child):
		return
	
	var slot: int = choose_child_slot(child)
	if slot == -1:
		return
	
	Global.game_manager.player.camera.drop_if_specific_selected(child)
	
	children.append(child)
	
	move_to_slot(child, slot)


func choose_child_slot(_child: Node3D) -> int:
	if children.size() >= hold_positions.size():
		return -1
	return children.size()


func move_to_slot(child: Node3D, slot: int) -> void:
	Global.set_dependance(self, child, true)
	set_child_position.call_deferred(child, slot)


func set_child_position(child: Node3D, slot: int) -> void:
	# Align child's position and rotation with this node
	var new_pos: Node3D = hold_positions[slot]
	child.global_transform = new_pos.global_transform
	offset_added_child(child)


func offset_added_child(_child: Node3D):
	pass


func get_slot_occupant(slot: int) -> Node3D:
	if slot >= children.size():
		return null
	return children[slot]


func _on_body_exited(body: Node) -> void:
	# Remove the body from the recently removed list if it's no longer in range0
	removed_children.erase(body)
