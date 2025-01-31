extends SubViewportContainer

func _ready() -> void:
	$SubViewport.reparent.call_deferred(get_parent())
