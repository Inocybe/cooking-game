class_name WeatherManager extends Node


enum WeatherType {
	Sunny,
	Overcast,
	Rainy,
	Stormy
}


func set_from_town(town: TownResource) -> void:
	Global.game_manager.clouds.set_starting_storminess(
		get_weather_storminess(town.weather)
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
	return WeatherManager.WeatherType.find_key(weather_type).to_lower()
