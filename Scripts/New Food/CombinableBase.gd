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
		removed_children.append(object)
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
	# Ensure the body is a valid food object and can be combined
	if is_compatible_with(body):
		add_as_child(body as Holdable)


func add_as_child(child: Holdable) -> void: 
	# Reparent the child under this node and disable its collider
	child.reparent(self)
	set_dependance(child, true)

	# Drop the child object if it's currently selected
	game_manager.player.camera.drop_if_selected()

	# Align child's position and rotation with this node
	child.global_transform = hold_positions
	
	# Add child to the list of childed objects
	children.append(child)


func _on_body_exited(body: Node) -> void:
	# Remove the body from the recently removed list if it's no longer in range
	if body in removed_children:
		removed_children.erase(body)
