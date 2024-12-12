extends MeshInstance3D


func _ready() -> void:
	%"Fryer Base".food_exit_enter.connect(on_food_exit_enter)
	set_oil_active(false)


func set_oil_active(active: bool) -> void:
	var bubble_radius: float = 1 if active else 0
	get_active_material(0).set_shader_parameter("max_bubble_radius", bubble_radius)


func on_food_exit_enter(cookwear: CookwearBase) -> void:
	set_oil_active(cookwear.food_cooking.size() > 0)
