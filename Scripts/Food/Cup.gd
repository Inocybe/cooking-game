extends BasicFood


var spill_scene = preload("res://Scenes/environment/spill.tscn")

@export var spill_angle: float = PI / 3

@export var spill_count: int = 3
@export var max_spill_distance: float = 10

var filled_with: StandardMaterial3D = null


func is_upside_down() -> bool:
	return facing_direction().angle_to(Vector3.UP) > spill_angle


func do_fill(material: StandardMaterial3D) -> void:
	if is_upside_down() or filled_with == material:
		return
		
	$Liquid.set_surface_override_material(0, material)
	$Fill.stop(false)
	$Fill.play("Fill")
	
	filled_with = material


func _ready() -> void:
	super()


func _physics_process(delta: float) -> void:
	super(delta)
	
	if is_upside_down() and filled_with != null:
	#if filled_with != null and has_fallen():
		spill_liquid()


func spill_liquid() -> void:
	$Fill.stop(false)
	
	var from: Vector3 = global_position
	var to: Vector3 = from + Vector3.DOWN * max_spill_distance
	var space = get_world_3d().direct_space_state
	var mask: int = 4
	var ray_query = PhysicsRayQueryParameters3D.create(from, to, mask)
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


func get_quality() -> float:
	if filled_with == null:
		return 0.5
	return 1
