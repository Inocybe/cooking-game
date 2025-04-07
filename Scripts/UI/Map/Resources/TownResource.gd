class_name TownResource extends Resource


const temp_min: float = -10.0
const temp_max: float = 46.0

const pop_min: int = 50
const pop_max: int = 500


@export_range(temp_min, temp_max, 0.5) var temperature: float
@export_range(pop_min, pop_max, 1) var population: int
@export var weather: WeatherManager.WeatherType

func random_everything() -> void:
	random_temperature()
	random_population()
	random_weather_off_temp()

func random_temperature() -> void:
	temperature = snappedf(randf_range(temp_min, temp_max), 0.01)

func random_population() -> void:
	population = randi_range(pop_min, pop_max)

func random_weather_off_temp() -> void:
	# NOT IMPLEMENTED OFF TEMP YET
	weather = WeatherManager.WeatherType.values().pick_random()
