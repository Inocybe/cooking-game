extends Node


var player_input_enabled = true

var game_manager: GameManager = null
var order_manager: OrderManager = null

var current_scene: Node3D = null


func _ready():
	if get_tree().current_scene:
		current_scene = get_tree().current_scene  # Reference to the current scene
	else:
		current_scene = null
	find_managers()


# This function looks for managers when a new scene is loaded or in the current scene
func find_managers():
	if not current_scene:
		return
	
	game_manager = current_scene.get_node_or_null("GameManager")
	if game_manager:
		order_manager = game_manager.get_node_or_null("OrderManager")


func pause_game() -> void:
	get_tree().paused = true

	
func resume_game() -> void:
	get_tree().paused = false


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
