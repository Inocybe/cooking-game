extends Node


var player_input_enabled = true

var game_manager: GameManager = null


func _ready():
	var current_scene = get_tree().current_scene
	
	if not current_scene:
		return
	
	game_manager = current_scene.get_node_or_null("GameManager")

func _process(delta: float) -> void:
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
