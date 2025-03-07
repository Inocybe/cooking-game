extends Node3D

const DESKOPUI_MAIN_MENU = preload("res://Scenes/ui/main/deskopui_main_menu.tscn")
const XRUI_MAIN_MENU = preload("res://Scenes/ui/main/xrui_main_menu.tscn")
@onready var game_manager: GameManager = $GameManager

var desktop_ui: Control
var xr_ui

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	desktop_ui = DESKOPUI_MAIN_MENU.instantiate()
	Global.current_scene.add_child(desktop_ui)
	
	
	game_manager.connect("XR_Detected", on_xr_detection)
	Global.order_manager.queue_free()
	

func on_xr_detection() -> void:
	desktop_ui.free()
	xr_ui = XRUI_MAIN_MENU.instantiate()
	Global.current_scene.add_child(xr_ui)
	
	
	#visibility_change_children(xrui, false)
	#visibility_change_children(desktop_ui, true)
#
#
#func visibility_change_children(parent: Node3D, see: bool) -> void:
	#var children: Array[Node] = parent.get_children()
	#parent.visible = see
	#for child in children:
		#visibility_change_children(child, see)
