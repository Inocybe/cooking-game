extends Node

var xr_interface: XRInterface
var initilized: bool = false

func _ready():
	xr_interface = XRServer.find_interface("OpenXR")
	if xr_interface and xr_interface.is_initialized():
		print("OpenXR winitialized successfully")
		
		# Turn off v-sync!
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
		
		# Change our main viewport to output to the HMD
		get_viewport().use_xr = true
		initilized = true
	else:
		print("OpenXR not initialized, please check if your headset is connected")

	
	#get_parent().open_xr_initialized(initilized, self)
