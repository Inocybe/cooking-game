class_name WeatherManager extends Node


enum WeatherType {
	Sunny,
	Overcast,
	Rainy,
	Stormy
}


var clouds: Clouds = null
var rain_area: RainArea = null


func _ready() -> void:
	var current_scene = get_tree().current_scene
	clouds = current_scene.get_node_or_null("Clouds")
	rain_area = current_scene.get_node_or_null("RainArea")


func set_from_town(town: TownResource) -> void:
	clouds.set_starting_storminess(
		get_weather_storminess(town.weather)
	)
	
	rain_area.set_raininess(
		get_weather_raininess(town.weather)
	)


static func get_weather_storminess(weather_type: WeatherType) -> float:
	return {
		WeatherType.Sunny: 0,
		WeatherType.Overcast: 1,
		WeatherType.Rainy: 0.8,
		WeatherType.Stormy: 1
	}[weather_type]


static func get_weather_raininess(weather_type: WeatherType) -> float:
	return {
		WeatherType.Sunny: 0,
		WeatherType.Overcast: 0,
		WeatherType.Rainy: 0.5,
		WeatherType.Stormy: 1
	}[weather_type]


static func get_weather_name(weather_type: WeatherType) -> String:
	return {
		WeatherType.Sunny: "sunny",
		WeatherType.Overcast: "overcast",
		WeatherType.Rainy: "rainy",
		WeatherType.Stormy: "stormy"
	}[weather_type]
