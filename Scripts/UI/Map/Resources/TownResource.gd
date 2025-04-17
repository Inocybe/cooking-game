class_name TownResource extends Resource


const pop_min: int = 50
const pop_max: int = 500

@export var name: String
@export var town_int: int = 0
@export_range(pop_min, pop_max, 1) var population: int
var temperature: float
var weather: WeatherManager.WeatherType


func random_weather() -> void:
	weather = WeatherManager.WeatherType.values().pick_random()
	
	temperature = snappedf(randf_range(
		WeatherManager.get_weather_min_temp(weather),
		WeatherManager.get_weather_max_temp(weather)
	), 0.01)
