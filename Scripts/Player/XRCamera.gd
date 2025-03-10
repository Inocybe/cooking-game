extends XRCamera3D


var xr_origin: XRManager
var player: Player

@export var turn_sensitivity: float = 3


func _ready() -> void:
	player = Global.game_manager.return_player()
	xr_origin = get_parent()


func forward_vector() -> Vector3:
	return -global_transform.basis.z


func _process(delta: float) -> void:
	if player:
		player.global_rotation.y = global_rotation.y
		if Global.game_manager.vr_move_mode == GameManager.VRMoveMode.CHAIR:
			xr_origin.global_position = player.feet.global_position
		elif Global.game_manager.vr_move_mode == GameManager.VRMoveMode.WALK:
			player.global_position.x = global_position.x
			player.global_position.z = global_position.z
		
		if Global.game_manager.vr_move_mode == Global.game_manager.VRMoveMode.CHAIR:
			var input_rotation: float = -xr_origin.right_hand.get_vector2("primary").x
			xr_origin.rotate_y(delta * input_rotation * turn_sensitivity)
	
