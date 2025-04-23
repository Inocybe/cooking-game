class_name MapIcons


static func WeatherToIcon(type: WeatherManager.WeatherType) -> String:
	match type:
		WeatherManager.WeatherType.Sunny:
			return "res://Assets/Icons/clear-day.svg"
		WeatherManager.WeatherType.Overcast:
			return "res://Assets/Icons/cloudy.svg"
		WeatherManager.WeatherType.Rainy:
			return "res://Assets/Icons/rainy-3.svg"
		WeatherManager.WeatherType.Stormy:
			return "res://Assets/Icons/thunderstorms.svg"
		WeatherManager.WeatherType.Snowy:
			return "res://Assets/Icons/snowy-3.svg"
		_:
			return ""
