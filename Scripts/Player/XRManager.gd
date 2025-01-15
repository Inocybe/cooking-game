class_name XRManager extends Node


@onready var left_hand: XRController3D = $"Left Hand"
@onready var right_hand: XRController3D = $"Right Hand"

var xr_interface: XRInterface


func _ready():
	# Turn off v-sync!
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
	
	# Change our main viewport to output to the HMD
	get_viewport().use_xr = true
