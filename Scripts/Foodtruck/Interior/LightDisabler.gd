extends Light3D


func _ready() -> void:
	Global.game_manager.XR_detected.connect(queue_free)
