@tool
extends SubViewport

func _ready() -> void:
	var mesh: MeshInstance3D
	for child in get_parent().get_children():
		if child is MeshInstance3D:
			mesh = child
			break
	if mesh:
		var material: StandardMaterial3D = mesh.get_active_material(0)
		#material.albedo_texture.
