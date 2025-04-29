class_name MapControl extends Control


const WORLD_SCENE: String = "res://Scenes/mains/world.tscn"

var is_loading_world: bool = false

@export var map_buttons: Array[MapButton]


func _ready() -> void:
	ResourceLoader.load_threaded_request(WORLD_SCENE)
	
	init_map_buttons()
	
	%StoreAlertBadge.visible = not StoreControl.has_recommended_food_amounts()
	
	# don't show the store button on day 1
	if ProgressManager.day == 1:
		%StatsBox.remove_switch_scene()


func init_map_buttons() -> void:
	for map_button: MapButton in map_buttons:
		map_button.world_load_requested.connect(load_world)
		map_button.init_town()


func load_world() -> void:
	if is_loading_world:
		return
	
	$LoadingControl.visible = true
	is_loading_world = true


func _process(_delta: float) -> void:
	if not is_loading_world:
		return
	
	var load_status = ResourceLoader.load_threaded_get_status(WORLD_SCENE)
	if load_status == ResourceLoader.THREAD_LOAD_LOADED:
		var world_scene = ResourceLoader.load_threaded_get(WORLD_SCENE)
		Global.switch_scenes(world_scene)
