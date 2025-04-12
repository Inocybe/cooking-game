extends Node3D

const XR_MENU_SYSTEM = preload("res://Scenes/player/vr/xr_menu_system.tscn")


var xr_manager: Node3D

var desktop_ui: Node3D = null
var xr_ui: Node3D = null


func _ready() -> void:
	Global.game_manager.order_manager.free()


func free_desktop_ui() -> void:
	desktop_ui.free()
