extends Holdable

func set_liquid(material: StandardMaterial3D) -> void:
	$Liquid.set_surface_override_material(0, material)

func play_fill_animation() -> void:
	$Fill.play("Fill")
