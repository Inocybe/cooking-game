extends XRCamera3D


var xr_origin: XRManager
var player: Player = null

@export var turn_sensitivity: float = 3


func _ready() -> void:
	xr_origin = get_parent()
	Global.game_state_set.connect(on_game_state_set)


func on_game_state_set() -> void:
	if Global.game_manager:
		player = Global.game_manager.player
	else:
		player = null


func forward_vector() -> Vector3:
	return -global_transform.basis.z


func _process(delta: float) -> void:
	if player:
		player.global_rotation.y = global_rotation.y
		if SettingsManager.vr_move_mode == SettingsManager.VRMoveMode.CHAIR:
			xr_origin.global_position = player.feet.global_position
		elif SettingsManager.vr_move_mode == SettingsManager.VRMoveMode.WALK:
			player.global_position.x = global_position.x
			player.global_position.z = global_position.z
		
		if SettingsManager.vr_move_mode == SettingsManager.VRMoveMode.CHAIR:
			var input_rotation: float = -xr_origin.right_hand.get_vector2("primary").x
			xr_origin.rotate_y(delta * input_rotation * turn_sensitivity)
	
