extends MeshInstance3D


func set_material(material: Material):
	set_surface_override_material(0, material)
