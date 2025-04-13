extends Node


const XR_SYSTEM = preload("res://Scenes/player/vr/xr_system.tscn")

var player_input_enabled = true

var game_manager: GameManager = null

var xr_manager: XRManager = null


signal has_XR_detected(has_XR: bool)


func _ready():
	var current_scene = get_tree().current_scene
	
	if not current_scene:
		return
	
	game_manager = current_scene.get_node_or_null("GameManager")
	
	check_XR()


func check_XR() -> void:
	var xr_interface = XRServer.find_interface("OpenXR")
	if xr_interface and xr_interface.is_initialized():
		xr_manager = XR_SYSTEM.instantiate()
		xr_manager.xr_interface = xr_interface
		get_tree().get_root().add_child.call_deferred(xr_manager)
		has_XR_detected.emit.call_deferred(true)
	else:
		has_XR_detected.emit.call_deferred(false)


func is_vr_avaliable() -> bool:
	return xr_manager != null and xr_manager.is_avaliable


func _process(_delta: float) -> void:
	if get_tree().current_scene:
		game_manager = get_tree().current_scene.get_node_or_null("GameManager")


func pause_game() -> void:
	get_tree().paused = true

	
func resume_game() -> void:
	get_tree().paused = false


func switch_scenes(scene_path: String) -> void:
	get_tree().change_scene_to_file(scene_path)


func debug_ray(from: Vector3, diff: Vector3, color: Color = Color.CHARTREUSE, width: float = 3):
	var camera: Camera = game_manager.player.camera
	game_manager.player.debug_display.add_ray(
		camera.unproject_position(from), 
		camera.unproject_position(from + diff),
		color, width
	)


func frame_lerp(from: float, to: float, speed: float, delta: float):
	var lerp_amount: float = 1 - (1 - speed) ** delta
	return lerp(from, to, lerp_amount)


func set_dependance(parent: Node3D, child: RigidBody3D, dependance: bool) -> void:
	child.freeze = dependance
	child.freeze_mode = RigidBody3D.FREEZE_MODE_STATIC
	if dependance:
		if parent is CollisionObject3D:
			child.add_collision_exception_with(parent)
		var transform = child.global_transform
		if child.get_parent():
			child.get_parent().remove_child(child)
		parent.add_child(child)
		child.global_transform = transform
	else:
		if parent is CollisionObject3D:
			child.remove_collision_exception_with(parent)
		child.reparent(get_tree().current_scene)


func weighted_random_int(weights: Array) -> int:
	var total_weight: float = 0
	for weight in weights:
		total_weight += weight
	var value: float = randf() * total_weight
	var range_min = 0
	for i in range(len(weights)):
		var range_max = range_min + weights[i]
		if value < range_max:
			return i
		range_min = range_max
	return -1 # unreachable


func weighted_random_val(values: Dictionary) -> Variant:
	return values.keys()[weighted_random_int(values.values())]
