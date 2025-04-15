class_name TownResource extends Resource


const pop_min: int = 50
const pop_max: int = 500

@export var town_int: int = 0
@export var temperature: float
@export_range(pop_min, pop_max, 1) var population: int
@export var weather: WeatherManager.WeatherType


func random_everything() -> void:
	random_weather()
	random_temperature()
	random_population()


func random_weather() -> void:
	weather = WeatherManager.WeatherType.values().pick_random()


func random_temperature() -> void:
	temperature = snappedf(randf_range(
		WeatherManager.get_weather_min_temp(weather),
		WeatherManager.get_weather_max_temp(weather)
	), 0.01)


func random_population() -> void:
	population = randi_range(pop_min, pop_max)
