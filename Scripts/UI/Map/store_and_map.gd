extends Node3D

const XR_MENU_SYSTEM = preload("res://Scenes/player/vr/xr_menu_system.tscn")

var xr_manager: Node3D

var desktop_ui: Node3D = null
var xr_ui: Node3D = null


func _ready() -> void:
	check_xr()


func free_desktop_ui() -> void:
	desktop_ui.free()


func on_xr_detection() -> void:
	free_desktop_ui()
	xr_ui = XR_MENU_SYSTEM.instantiate()


func check_xr() -> void:
	var xr_interface = XRServer.find_interface("OpenXR")
	if xr_interface and xr_interface.is_initialized():
		print("OpenXR initialized successfully")
		xr_manager = XR_MENU_SYSTEM.instantiate()
		xr_manager.xr_interface = xr_interface
		get_tree().get_root().add_child.call_deferred(xr_manager)
		
		on_xr_detection()
