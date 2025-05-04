extends MeshInstance3D


func _ready() -> void:
	%"Fryer Base".food_exit_enter.connect(on_food_exit_enter)
	set_oil_active(false)


func set_oil_active(active: bool) -> void:
	var bubble_radius: float = 1 if active else 0
	get_active_material(0).set_shader_parameter("max_bubble_radius", bubble_radius)


func on_food_exit_enter(cookwear: CookwearBase) -> void:
	var is_cooking = cookwear.food_cooking.size() > 0
	set_oil_active(is_cooking)
	return
	var frying_audio = $FryingAudioPlayer
	if is_cooking:
		frying_audio.fade_in()
	else:
		frying_audio.fade_out()
