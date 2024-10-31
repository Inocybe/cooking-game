class_name CombinableBase extends Holdable


@export var combine_range: Area3D = null
@export var hold_positions: Array[Node3D] = []

var children: Array[Node3D] = []
var removed_children: Array[Node3D] = []


func set_dependance(child: Holdable, disable: bool) -> void:
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


func unparent_children() -> void:
	for child in children:
		child.reparent(Global.current_scene)
		removed_children.append(child)
		set_dependance(child, false)


func _ready() -> void:
	super()
	# Connect combine range signals if present
	if combine_range:
		combine_range.connect("body_entered", _on_body_entered)
		combine_range.connect("body_exited", _on_body_exited)


func is_compatible_with(other: Node):
	return other.is_in_group("food") and other != self and not removed_children.has(other)


func _on_body_entered(body: Node) -> void:
	if children.size() >= hold_positions.size():
		return
	if not is_compatible_with(body):
		return
	add_as_child(body as Holdable)


func add_as_child(child: Holdable) -> void: 
	if children.has(child):
		return
	
	# Add child to the list of childed objects
	children.append(child)
	
	# Reparent the child under this node and disable its collider
	child.reparent(self)
	set_dependance(child, true)

	# Drop the child object if it's currently selected
	Global.game_manager.player.camera.drop_if_specific_selected(child)

	# Align child's position and rotation with this node
	var new_pos: Node3D = hold_positions[children.size()-1]
	child.global_transform = new_pos.global_transform


func _on_body_exited(body: Node) -> void:
	# Remove the body from the recently removed list if it's no longer in range
	if removed_children.has(body):
		removed_children.erase(body)
