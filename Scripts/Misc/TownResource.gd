class_name TownResource extends Resource


@export var name: String
@export var town_int: int
@export var population: int
@export var opening_hours: float
var temperature: float
var weather: WeatherManager.WeatherType


func random_weather() -> void:
	weather = WeatherManager.WeatherType.values().pick_random()
	
	temperature = snappedf(randf_range(
		WeatherManager.get_weather_min_temp(weather),
		WeatherManager.get_weather_max_temp(weather)
	), 0.01)
