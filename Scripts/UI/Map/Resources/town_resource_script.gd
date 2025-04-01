class_name town extends Resource

var weather_types: Dictionary[int, String] = {
	0: "overcast",
	1: "sunny",
	2: "ranny",
	3: "storm",
	4: "unknown"
}

const temp_min: float = -10.0
const temp_max: float = 46.0

const pop_min: int = 50
const pop_max: int = 500


@export_range(temp_min, temp_max, 0.5) var tempurature: float
@export_range(pop_min, pop_max, 1) var population: int
@export var weather: String

func random_everything() -> void:
	random_tempurature()
	random_population()
	random_weather_off_temp()

func random_tempurature() -> void:
	tempurature = snappedf(randf_range(temp_min, temp_max), 0.01)

func random_population() -> void:
	population = randi_range(pop_min, pop_max)

func random_weather_off_temp() -> void:
	# NOT IMPLEMENTED OFF TEMP YET
	var i: int = randi_range(0, weather_types.size() - 1) 
	weather = weather_types[i]
