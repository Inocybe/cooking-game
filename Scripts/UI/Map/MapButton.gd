extends Control


const SCENE_ATTACHED: String = "res://Scenes/mains/world.tscn"

@onready var town: TownResource = TownResource.new()
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var label: RichTextLabel = $TextHolder/TextPanel/TextMargin/Text

@export var position_fraction: Vector2

var town_values_shown: bool = false


func _ready() -> void:
	$Button.pressed.connect(on_button_pressed)
	
	get_parent().resized.connect(reposition)
	reposition()
	
	town.random_everything()
	set_town_values()
	async_load()


func reposition() -> void:
	position = position_fraction * get_parent().size


func on_button_pressed() -> void:
	if town_values_shown:
		town_values_shown = false
		Global.town = town
		Global.switch_scenes(ResourceLoader.load_threaded_get(SCENE_ATTACHED))
	else:
		town_values_shown = true
		animation_player.play("display_town_values")


func set_town_values() -> void:
	var weather_name = WeatherManager.get_weather_name(town.weather)
	label.text = """Weather: %s
Temperature: %s°C
Population: %s""" % [
		weather_name, str(town.temperature), str(town.population)
	]


func async_load() -> void:
	ResourceLoader.load_threaded_request(SCENE_ATTACHED)
