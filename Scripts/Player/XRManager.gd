class_name XRManager extends XROrigin3D


@onready var camera: XRCamera3D = $XRCamera3D
@onready var left_hand: XRController3D = $"Left Hand"
@onready var right_hand: XRController3D = $"Right Hand"

var xr_interface: XRInterface
var is_avaliable: bool = false

enum Hand_States {
	idle,
	point,
	grab
}


func _ready():
	# Turn off v-sync!
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
	
	# Change our main viewport to output to the HMD
	get_viewport().use_xr = true
	
	is_avaliable = true
	
	xr_interface.xr_play_area_mode = XRInterface.XR_PLAY_AREA_ROOMSCALE
	
	if Global.game_manager:
		if Global.game_manager.return_player():
			global_transform = Global.game_manager.player.feet.global_transform
