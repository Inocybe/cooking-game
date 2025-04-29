class_name TownResource extends Resource

const forcast_length: int = 3

@export var name: String
@export var town_int: int
@export var population: int
@export var opening_hours: float

var weather_forcast: Array[WeatherManager.WeatherType]
var temp_forcast: Array[float]


func random_forcast(day: int) -> void:
	weather_forcast.clear()
	temp_forcast.clear()
	for i in range(forcast_length):
		set_weather_seed(day + i)
		weather_forcast.append(get_random_weather())
		temp_forcast.append(get_random_temp(weather_forcast[i]))


func set_weather_seed(day: int):
	seed(hash(ProgressManager.rand_seed + day))


func get_random_weather() -> WeatherManager.WeatherType:
	return WeatherManager.WeatherType.values().pick_random()


func get_random_temp(weather: WeatherManager.WeatherType) -> float:
	return snappedf(randf_range(
		WeatherManager.get_weather_min_temp(weather),
		WeatherManager.get_weather_max_temp(weather)
	), 0.01)
