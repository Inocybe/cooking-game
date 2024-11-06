class_name Cookable extends Node


@export var cook_time: float = 0.2
@export var burn_multiple: float = 2
@export var uncooked_color: Color
@export var cooked_color: Color
@export var burnt_color: Color
@export var required_cooking_type: CookwearBase.CookingType
@export var mesh_glob = "*"

var cooked_amount: float = 0
var cooking: bool = false
var is_cooked: bool = false
var is_burnt: bool = false
var material: StandardMaterial3D = StandardMaterial3D.new()


func _ready() -> void:
	for mesh in get_parent().find_children(mesh_glob, "MeshInstance3D"):
		mesh.set_surface_override_material(0, material)


func on_start_cooking(cooking_type: CookwearBase.CookingType) -> void:
	if required_cooking_type == cooking_type:
		cooking = true


func on_stop_cooking(cooking_type: CookwearBase.CookingType) -> void:
	if required_cooking_type == cooking_type:
		cooking = false


func _process(delta: float) -> void:
	if cooking and not is_burnt:
		cooked_amount += delta / cook_time
	
	if cooked_amount > 1:
		is_cooked = true
	
	if cooked_amount > burn_multiple:
		cooked_amount = burn_multiple
	
	var new_color: Color
	
	if cooked_amount < 1:
		new_color = uncooked_color.lerp(cooked_color, cooked_amount)
	else:
		var burn_amount: float = (cooked_amount - 1) / (burn_multiple - 1)
		new_color = cooked_color.lerp(burnt_color, burn_amount)
	
	material.albedo_color = new_color


func get_is_cooked() -> bool:
	return is_cooked


func get_is_burnt() -> bool:
	return is_burnt
