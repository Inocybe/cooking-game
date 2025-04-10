class_name Cookable extends Node


@export_group("Cook Settings")
@export var required_cooking_type: CookwearBase.CookingType
@export var cook_time: float = 0.2
@export var burn_time_multiple: float = 2
@export var raw_temperature: float = 30
@export var cooked_temperature: float = 70
@export var overcooked_temperature: float = 100

@export_group("Color")
@export var uncooked_color: Color
@export var cooked_color: Color
@export var burnt_color: Color

@export_group("Resources")
@export var mesh_glob = "*"
@export var cook_particles: GPUParticles3D
@export var cook_audio: AudioFader3D
@export var material_template: ShaderMaterial

var cooked_amount: float = 0
var cooking: bool = false
var is_cooked: bool = false
var is_burnt: bool = false
var material: ShaderMaterial


func _ready() -> void:
	material = material_template.duplicate(true)
	
	for mesh in get_parent().find_children(mesh_glob, "MeshInstance3D"):
		if mesh.get_surface_override_material(0) == null:
			mesh.set_surface_override_material(0, material)


func on_start_cooking(cooking_type: CookwearBase.CookingType) -> void:
	if required_cooking_type == cooking_type:
		cooking = true
		
		set_cooking_paticles(true)
		set_cooking_audio(true)


func on_stop_cooking(cooking_type: CookwearBase.CookingType) -> void:
	if required_cooking_type == cooking_type:
		cooking = false
		
		set_cooking_paticles(false)
		set_cooking_audio(false)


func get_burn_amount() -> float:
	return (cooked_amount - 1) / (burn_time_multiple - 1)


func _process(delta: float) -> void:
	if cooking and not is_burnt:
		cooked_amount += delta / cook_time
	
	if cooked_amount > 1:
		is_cooked = true
	
	if cooked_amount > burn_time_multiple:
		cooked_amount = burn_time_multiple
	
	var new_color: Color
	
	if cooked_amount < 1:
		new_color = uncooked_color.lerp(cooked_color, cooked_amount)
	else:
		new_color = cooked_color.lerp(burnt_color, get_burn_amount())
	
	material.set_shader_parameter("base_color", new_color)
	material.set_shader_parameter("cooked_amount", cooked_amount)


func get_is_cooked() -> bool:
	return is_cooked


func get_is_burnt() -> bool:
	return is_burnt


func get_quality() -> float:
	if cooked_amount < 1:
		return cooked_amount
	else:
		return 1 - get_burn_amount()


func get_temperature() -> float:
	if cooked_amount < 1:
		return raw_temperature + (cooked_temperature - raw_temperature) * cooked_amount
	else:
		return cooked_temperature + (overcooked_temperature - cooked_temperature) * get_burn_amount()


func set_cooking_paticles(enabled: bool) -> void:
	if cook_particles:
		cook_particles.emitting = enabled


func set_cooking_audio(enabled: bool) -> void:
	if cook_audio:
		if enabled:
			cook_audio.fade_in()
		else:
			cook_audio.fade_out()
