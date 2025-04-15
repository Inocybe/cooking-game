extends SubViewport


func _ready() -> void:
	Global.notify_has_XR(on_has_XR_detected)


func on_has_XR_detected(has_XR: bool) -> void:
	if has_XR:
		reparent.call_deferred(get_parent().get_parent())
