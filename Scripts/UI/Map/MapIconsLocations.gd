class_name MapIcons


static func WeatherToIcon(type: WeatherManager.WeatherType) -> String:
	match type:
		WeatherManager.WeatherType.Sunny:
			return "res://Assets/Map/weather-icons-main/animated/clear-day.svg"
		WeatherManager.WeatherType.Overcast:
			return "res://Assets/Map/weather-icons-main/animated/cloudy.svg"
		WeatherManager.WeatherType.Rainy:
			return "res://Assets/Map/weather-icons-main/animated/rainy-3.svg"
		WeatherManager.WeatherType.Stormy:
			return "res://Assets/Map/weather-icons-main/animated/thunderstorms.svg"
		WeatherManager.WeatherType.Snowy:
			return "res://Assets/Map/weather-icons-main/animated/snowy-3.svg"
		_:
			return ""
