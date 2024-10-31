extends Node3D


@export var cook_time: float = 10
@export var uncooked_color: Color
@export var cooked_color: Color

var cooked_amount: float = 0
var cooking: bool = false
var is_cooked: bool = false
var material: StandardMaterial3D = StandardMaterial3D.new()


func _ready() -> void:
	for mesh in get_parent().find_children("*", "MeshInstance3D"):
		mesh.set_surface_override_material(0, material)


func on_start_cooking() -> void:
	cooking = true


func on_stop_cooking() -> void:
	cooking = false


func _process(delta: float) -> void:
	if cooking and not is_cooked:
		cooked_amount += delta / cook_time
	
	if cooked_amount > 1:
		is_cooked = true
		cooked_amount = 1
	
	material.albedo_color = uncooked_color.lerp(cooked_color, cooked_amount)


func get_is_cooked() -> bool:
	return is_cooked
