extends Node


enum VRToggleMode {
	EnableOnVR,
	DisableOnVR
}

@export var mode: VRToggleMode = VRToggleMode.DisableOnVR


func _ready() -> void:
	Global.notify_has_XR(on_has_XR_detected)


func on_has_XR_detected(has_XR: bool) -> void:
	if has_XR and mode == VRToggleMode.DisableOnVR:
		queue_free()
	elif not has_XR and mode == VRToggleMode.EnableOnVR:
		queue_free()
