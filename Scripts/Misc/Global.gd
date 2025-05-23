extends Node


enum GameState {
	WORLD,
	MENU
}


const XR_SYSTEM = preload("res://Scenes/player/vr/xr_system.tscn")

const PRESS_SOUND_PLAYER = preload("res://Scenes/misc/press_sound_player.tscn")


var game_manager: GameManager = null
var xr_manager: XRManager = null
var press_sound_player: AudioStreamPlayer

var music_pitch_shift: AudioEffectPitchShift = AudioEffectPitchShift.new()

var game_state: GameState = GameState.MENU

var town: TownResource

var has_XR_known: bool = false
var has_XR: bool

var font_size_fraction: float = 0.03


var set_window_title: bool = false


signal has_XR_detected(has_XR: bool)

signal game_state_set()

signal font_size_changed()


func _ready():
	var current_scene = get_tree().current_scene
	
	AudioServer.add_bus_effect(
		AudioServer.get_bus_index("Music"),
		music_pitch_shift
	)
	
	if not current_scene:
		return
	
	game_manager = current_scene.get_node_or_null("GameManager")
	
	check_XR()
	
	enable_button_sounds()


func create_XR_manager(xr_interface: XRInterface) -> void:
	xr_manager = XR_SYSTEM.instantiate()
	xr_manager.xr_interface = xr_interface
	get_tree().get_root().add_child.call_deferred(xr_manager)


func check_window_resizes() -> void:
	get_tree().get_root().size_changed.connect(on_window_resize)
	on_window_resize()


func on_window_resize() -> void:
	ThemeDB.get_project_theme().default_font_size = round(
		get_viewport().size.y * font_size_fraction
	)
	
	font_size_changed.emit()


func notify_has_XR(function: Callable) -> void:
	if has_XR_known:
		function.call(Global.has_XR)
	else:
		has_XR_detected.connect(function)


func check_XR() -> void:
	var xr_interface = XRServer.find_interface("OpenXR")
	has_XR = xr_interface and xr_interface.is_initialized()
	
	if has_XR:
		create_XR_manager(xr_interface)
	else:
		check_window_resizes()
	
	has_XR_detected.emit.call_deferred(has_XR)
	has_XR_known = true


func is_vr_avaliable() -> bool:
	return xr_manager != null and xr_manager.is_avaliable


func _process(_delta: float) -> void:
	if not set_window_title:
		DisplayServer.window_set_title(
			"Burger Box", get_window().get_window_id())
		set_window_title = true
	
	if get_tree().current_scene and game_manager == null:
		game_manager = get_tree().current_scene.get_node_or_null("GameManager")


func enable_button_sounds() -> void:
	press_sound_player = PRESS_SOUND_PLAYER.instantiate()
	get_tree().root.add_child.call_deferred(press_sound_player)
	
	for child in get_tree().root.find_children("*", "Button", true, false):
		add_button_press_sound(child)
	
	get_tree().node_added.connect(func(node):
		if node is Button:
			add_button_press_sound(node)
	)


func add_button_press_sound(btn: Button):
	btn.pressed.connect(press_sound_player.play)


func set_game_state(state: GameState):
	game_state = state
	if state == GameState.MENU:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	game_state_set.emit()


func pause_game() -> void:
	get_tree().paused = true

	
func resume_game() -> void:
	get_tree().paused = false


func switch_scenes(scene: PackedScene) -> void:
	get_tree().change_scene_to_packed(scene)


func switch_scenes_with_path(scene: String) -> void:
	get_tree().change_scene_to_file(scene)


func debug_ray(from: Vector3, diff: Vector3, color: Color = Color.CHARTREUSE,
		width: float = 3):
	var camera: PlayerCamera = game_manager.player.camera
	game_manager.player.debug_display.add_ray(
		camera.unproject_position(from), 
		camera.unproject_position(from + diff),
		color, width
	)


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
