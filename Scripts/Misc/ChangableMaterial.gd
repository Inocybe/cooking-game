extends MeshInstance3D


func set_material(material: StandardMaterial3D):
	set_surface_override_material(0, material)
