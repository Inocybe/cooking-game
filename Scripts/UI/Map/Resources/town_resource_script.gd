class_name town extends Resource

enum weather_types {
	overcast, 
	sunny,
	runny,
	storm,
	unknown
}

const temp_min: float = -10.0
const temp_max: float = 34.0

const pop_min: int = 50
const pop_max: int = 500


@export_range(temp_min, temp_max, 0.5) var tempurature: float
@export_range(pop_min, pop_max, 1) var population: int
@export var weather: weather_types

func random_everything() -> void:
	random_tempurature()
	random_population()
	random_weather_off_temp()

func random_tempurature() -> void:
	tempurature = randf_range(temp_min, temp_max)

func random_population() -> void:
	population = randi_range(pop_min, pop_max)

func random_weather_off_temp() -> void:
	# NOT IMPLEMENTED OFF TEMP YET
	weather = weather_types.values()[randi() %weather_types.size()]
