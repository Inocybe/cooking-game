extends Holdable


@export var fry_time: float = 10
@export var unfryed_color: Color
@export var fryed_color: Color
@export var food_type: Menu.Item

var fryed_amount: float = 0
var frying: bool = false
var is_fryed: bool = false
var material: StandardMaterial3D = StandardMaterial3D.new()


func _ready() -> void:
	super()
	
	for mesh in find_children("Fry*", "MeshInstance3D"):
		mesh.set_surface_override_material(0, material)


func on_start_frying() -> void:
	frying = true


func on_stop_frying() -> void:
	frying = false


func _process(delta: float) -> void:
	if frying and not is_fryed:
		fryed_amount += delta / fry_time
	
	if fryed_amount > 1:
		is_fryed = true
		fryed_amount = 1
	
	material.albedo_color = unfryed_color.lerp(fryed_color, fryed_amount)


func get_is_fryed() -> bool:
	return is_fryed
	

func get_food_type() -> Menu.Item:
	return food_type
