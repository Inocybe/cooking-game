extends Holdable


var new_material: StandardMaterial3D

var material_changed: bool = false


func set_liquid(material: StandardMaterial3D) -> void:
	new_material = material
	material_changed = true


func do_fill() -> void:
	if not material_changed:
		return
	$Liquid.set_surface_override_material(0, new_material)
	material_changed = false
	$Fill.stop(false)
	$Fill.play("Fill")
