extends Button


const SCENE_ATTACHED: String = "res://Scenes/mains/world.tscn"

@onready var town: TownResource = TownResource.new()
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var label: TextEdit = $TextEdit

var displaying: bool = false


func start() -> void:
	town.random_everything()
	set_town_values()
	async_load()


func _on_pressed() -> void:
	print("pressed")
	if !displaying:
		displaying = true
		animation_player.play("display_town_values")
	else:
		displaying = false
		Global.town = town
		Global.switch_scenes(ResourceLoader.load_threaded_get(SCENE_ATTACHED))



func set_town_values() -> void:
	var weather_name = WeatherManager.get_weather_name(town.weather)
	label.set_line(0, "Weather: " + weather_name)
	label.set_line(1, "Temperature: " + str(town.temperature) + "°C")
	label.set_line(2, "Population: " + str(town.population))


func async_load() -> void:
	ResourceLoader.load_threaded_request(SCENE_ATTACHED)
