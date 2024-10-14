extends Holdable


var spill_scene = preload("res://Scenes/spill.tscn")

@export var spill_count = 3
@export var spill_angle = PI / 3
@export var max_spill_distance = 10

var filled_with: StandardMaterial3D = null


func do_fill(material: StandardMaterial3D) -> void:
	if has_fallen() or filled_with == material:
		return
	$Liquida
	$Fill.stop(false)
	$Fill.play("Fill")
	filled_with = material


func _physics_process(delta: float) -> void:
	super(delta)
	
	if filled_with != null and has_fallen():
		spill_liquid()


func has_fallen() -> bool:
	return facing_direction().angle_to(Vector3.UP) > spill_angle


func spill_liquid() -> void:
	$Fill.stop(false)
	
	var from: Vector3 = global_position
	var to: Vector3 = from + Vector3.DOWN * max_spill_distance
	var space = get_world_3d().direct_space_state
	var collision_mask: int = 4
	var ray_query = PhysicsRayQueryParameters3D.create(from, to, collision_mask)
	var ray_result: Dictionary = space.intersect_ray(ray_query)
	
	if ray_result != null and not ray_result.is_empty():
		for i in spill_count:
			generate_spill(ray_result.position)
	
	filled_with = null


func generate_spill(base_position: Vector3) -> void:
	var spill: Node3D = spill_scene.instantiate()
	spill.position = base_position
	spill.set_material(filled_with)
	get_tree().current_scene.add_child(spill)
