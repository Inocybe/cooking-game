extends Node


const shader_path = "res://Scripts/Shaders/TransparencyShader.gdshader"


func _ready() -> void:
	var parent: Node3D = get_parent()
	
	# Assuming the first child is the MeshInstance3D
	var model: Node3D = parent.get_child(0)
	
	for mesh in model.get_children():
		apply_transparency_fluctuation(mesh)


# Function to apply the transparency shader to a given food object
func apply_transparency_fluctuation(food_object: MeshInstance3D) -> void:
	# Load the shader
	var shader = load(shader_path)
	
	var shader_material = ShaderMaterial.new()
	shader_material.shader = shader
	
	#finds all unique materials on object
	for i in range(food_object.get_surface_override_material_count()):
		food_object.set_surface_override_material(i, shader_material)
