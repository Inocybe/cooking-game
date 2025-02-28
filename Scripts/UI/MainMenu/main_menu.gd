extends Node3D


@onready var game_manager: GameManager = $GameManager
@onready var xrui: Node3D = $XRUI
@onready var desktop_ui: Node3D = $DesktopUI

func _ready() -> void:
	game_manager.connect("XR_Detected", on_xr_detection)

func on_xr_detection() -> void:
	xrui.visible = true
	desktop_ui.visible = false
