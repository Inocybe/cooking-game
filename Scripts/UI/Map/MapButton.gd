extends Control


const WORLD_SCENE: String = "res://Scenes/mains/world.tscn"

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var label: RichTextLabel = %Text

@export var town: TownResource
@export var position_fraction: Vector2

var town_values_shown: bool = false


func _ready() -> void:
	get_parent().resized.connect(reposition)
	reposition()
	
	$Button.pressed.connect(on_button_pressed)
	$Button.text = " "+town.name+" "
	
	town.random_weather()
	show_town_values()
	async_load_world()


func reposition() -> void:
	position = position_fraction * get_parent().size


func on_button_pressed() -> void:
	if town_values_shown:
		town_values_shown = false
		Global.town = town
		var world_scene = ResourceLoader.load_threaded_get(WORLD_SCENE)
		Global.switch_scenes(world_scene)
	else:
		town_values_shown = true
		animation_player.play("display_town_values")


func show_town_values() -> void:
	var weather_name = WeatherManager.get_weather_name(town.weather)
	label.text = """Weather: %s
Temperature: %s°C
Population: %s""" % [
		weather_name, str(town.temperature), str(town.population)
	]


func async_load_world() -> void:
	ResourceLoader.load_threaded_request(WORLD_SCENE)
