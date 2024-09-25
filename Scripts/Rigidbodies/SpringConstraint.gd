extends Node


@export_enum("X", "Y", "Z") var axis: int
@export var spring_pos: float
@export var spring_len: float
@export var spring_constant: float
@export var is_solid: bool = true

var body: RigidBody3D


func _ready() -> void:
	body = get_parent()


func _physics_process(delta: float) -> void:
	var axis_pos: float = body.position[axis]
	var rel: float = axis_pos - spring_pos
	# is the end of the spring solid and if so are we past it?
	if is_solid and sign(rel) != sign(spring_len):
		body.linear_velocity[axis] = 0
		body.position[axis] = spring_pos
	if abs(rel) < abs(spring_len):
		var force: Vector3 = Vector3(0, 0, 0)
		force[axis] = (spring_len - rel) * spring_constant
		body.apply_central_force(force)
