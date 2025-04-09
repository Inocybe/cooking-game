extends DirectionalLight3D


func _ready() -> void:
	Global.game_manager.XR_detected.connect(disable_light)


func disable_light() -> void:
	sky_mode = DirectionalLight3D.SKY_MODE_SKY_ONLY
