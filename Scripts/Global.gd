extends Node


var player_input_enabled = true

var game_manager: Node = null
var order_manager: Node = null

func _ready():
	find_managers()

# This function looks for managers when a new scene is loaded or in the current scene
func find_managers():
	var current_scene = get_tree().current_scene  # Reference to the current scene
	if not current_scene:
		print("No current scene loaded!")
		return
	
	# Try to find the GameManager and OrderManager in the current scene tree
	game_manager = current_scene.get_node_or_null("GameManager")
	order_manager = current_scene.get_node_or_null("OrderManager")

	if game_manager:
		print("GameManager located in scene: ", game_manager)
	else:
		print("GameManager not found in the scene.")
	
	if order_manager:
		print("OrderManager located in scene: ", order_manager)
	else:
		print("OrderManager not found in the scene.")


func pause_game() -> void:
	get_tree().paused = true

	
func resume_game() -> void:
	get_tree().paused = false


func frame_lerp(from: float, to: float, speed: float, delta: float):
	var lerp_amount: float = 1 - (1 - speed) ** delta
	return lerp(from, to, lerp_amount)
