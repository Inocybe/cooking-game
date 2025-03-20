extends Node3D

const DESKTOP_MAIN_MENU = preload("res://Scenes/ui/controls/main_menu_control.tscn")
const XRUI_MAIN_MENU = preload("res://Scenes/ui/3d/xrui_main_menu.tscn")
const XR_MENU_SYSTEM = preload("res://Scenes/player/vr/xr_menu_system.tscn")

@onready var game_manager: GameManager = $GameManager

var desktop_ui: Control
var xr_ui: Node3D
var xr_manager: Node3D

func _ready() -> void:
	
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	desktop_ui = DESKTOP_MAIN_MENU.instantiate()
	get_tree().current_scene.add_child(desktop_ui)
	
	
	#game_manager.connect("XR_detected", on_xr_detection)
	#Global.order_manager.queue_free()
	
	check_xr()

func on_xr_detection() -> void:
	desktop_ui.free()
	xr_ui = XRUI_MAIN_MENU.instantiate()
	get_tree().current_scene.add_child(xr_ui)
	#game_manager.XR_system.left_hand.is_in_menu = true
	#game_manager.XR_system.right_hand.is_in_menu = true




func check_xr() -> void:
	var xr_interface = XRServer.find_interface("OpenXR")
	if xr_interface and xr_interface.is_initialized():
		print("OpenXR initialized successfully")
		xr_manager = XR_MENU_SYSTEM.instantiate()
		xr_manager.xr_interface = xr_interface
		get_tree().get_root().add_child.call_deferred(xr_manager)
		
		on_xr_detection()
	
	#visibility_change_children(xrui, false)
	#visibility_change_children(desktop_ui, true)

#
#func visibility_change_children(parent: Node3D, see: bool) -> void:
	#var children: Array[Node] = parent.get_children()
	#parent.visible = see
	#for child in children:
		#visibility_change_children(child, see)
