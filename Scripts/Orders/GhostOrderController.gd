extends Node


var shader = preload("res://Scripts/Shaders/TransparencyShader.gdshader")


func _ready() -> void:
	var parent: Node3D = get_parent()
	
	var shader_material = ShaderMaterial.new()
	shader_material.shader = shader
	
	for child in parent.find_children("*", "MeshInstance3D", true, false):
		for i in range(child.get_surface_override_material_count()):
			child.set_surface_override_material(i, shader_material)
