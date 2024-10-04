extends Holdable


var old_material: StandardMaterial3D = null


func do_fill(material: StandardMaterial3D) -> void:
	if old_material == material:
		return
	$Liquid.set_surface_override_material(0, material)
	$Fill.stop(false)
	$Fill.play("Fill")
	old_material = material
