extends Node

const shader_path = "res://Scripts/Shaders/TransparencyShader.gdshader"


func _ready() -> void:
	# this gets the parent and then the parent name then it finds the material attached to it because the model is the parents name but all lowercase
	var parent: Node3D = get_parent()
	
	# Assuming the first child is the MeshInstance3D
	var model: Node3D = parent.get_child(0)
	
	print(model.get_children())
	
	for mesh in model.get_children():
		for the_mesh in mesh.find_children("*", "MeshInstance3D"):
			apply_transparency_fluctuation(the_mesh)
			#the_mesh.get_surface_material(0)
	
	
	#if model != null:
	#	apply_transparency_fluctuation(model)
	#else:
	#	print("Error: No MeshInstance3D found on the parent node.")





# Function to apply the transparency shader to a given food object
func apply_transparency_fluctuation(food_object: Node) -> void:
	# Load the shader
	var shader = load(shader_path)
	
	# Check if the food object has a material
	if food_object.get_surface_material(0):
		# Get the existing material and make it ShaderMaterial
		var shader_material = ShaderMaterial.new()
		shader_material.shader = shader
		
		# Apply the shader material to the food object's first surface
		food_object.set_surface_material(0, shader_material)
	else:
		print("Error: Food object doesn't have a material to apply the shader to.")
