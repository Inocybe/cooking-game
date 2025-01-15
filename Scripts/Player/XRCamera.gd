extends XRCamera3D


var xr_origin: XROrigin3D
var player: Player


func _ready() -> void:
	player = Global.game_manager.player
	xr_origin = get_parent()


func _process(_delta: float) -> void:
	player.global_rotation.y = global_rotation.y
	if Global.game_manager.vr_move_mode == GameManager.VRMoveMode.CHAIR:
		xr_origin.global_position = player.feet.global_position
	elif Global.game_manager.vr_move_mode == GameManager.VRMoveMode.WALK:
		player.global_position.x = global_position.x
		player.global_position.z = global_position.z
