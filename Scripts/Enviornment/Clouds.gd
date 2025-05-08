class_name Clouds extends Node3D


@export var sun_manager: SunManager

@export var clear_empty_cutoff: float = 0.8
@export var storm_empty_cutoff: float = 0.3

@export var clear_max_depth_damp: float = 0
@export var storm_max_depth_damp: float = 0.6

@export var clear_sun_energy: float = 1
@export var storm_sun_energy: float = 0

@export var storminess_change_speed: float = 0.02

var current_storminess: float = 1
var target_storminess: float = 1


func set_starting_storminess(storminess: float) -> void:
	current_storminess = storminess
	target_storminess = storminess
	show_storminess(storminess)


func _process(delta: float) -> void:
	if current_storminess == target_storminess:
		return
	
	current_storminess = move_toward(
		current_storminess, target_storminess, storminess_change_speed * delta
	)
	
	show_storminess(current_storminess)


func set_shader_values(prop: String, val: Variant) -> void:
	for child: MeshInstance3D in get_children():
		var mat: ShaderMaterial = child.get_surface_override_material(0)
		mat.set_shader_parameter(prop, val)


func show_storminess(storminess: float) -> void:
	var empty_cutoff = lerpf(clear_empty_cutoff, storm_empty_cutoff, storminess)
	set_shader_values("empty_cutoff", empty_cutoff)
	
	var max_depth_damp = lerpf(clear_max_depth_damp, storm_max_depth_damp, storminess)
	set_shader_values("max_depth_damp", max_depth_damp)
	
	var sun_energy = lerpf(clear_sun_energy, storm_sun_energy, storminess)
	sun_manager.set_brightness(sun_energy)
