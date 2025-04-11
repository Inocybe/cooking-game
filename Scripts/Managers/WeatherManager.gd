class_name WeatherManager extends Node


enum WeatherType {
	Sunny,
	Overcast,
	Rainy,
	Stormy,
	Snowy
}


var clouds: Clouds = null
var rain_area: RainArea = null
var snow_area: SnowArea = null
var enviornment: EnvironmentManager = null
var lightning_manager: LightningManager = null


func _ready() -> void:
	var current_scene = get_tree().current_scene
	clouds = current_scene.get_node_or_null("Clouds")
	rain_area = current_scene.get_node_or_null("RainArea")
	snow_area = current_scene.get_node_or_null("SnowArea")
	enviornment = current_scene.get_node_or_null("WorldEnvironment")
	lightning_manager = current_scene.get_node_or_null("LightningManager")


func set_from_town(town: TownResource) -> void:
	var storminess = get_weather_storminess(town.weather)
	var raininess = get_weather_raininess(town.weather)
	var snowiness = get_weather_snowiness(town.weather)
	var lightning_chance = get_weather_lightning_chance(town.weather)
	
	clouds.set_starting_storminess(storminess)
	rain_area.set_raininess(raininess)
	snow_area.set_snowiness(snowiness)
	enviornment.set_raininess(raininess)
	lightning_manager.set_lightning_chance(lightning_chance)


static func get_weather_storminess(weather_type: WeatherType) -> float:
	return {
		WeatherType.Sunny: 0,
		WeatherType.Overcast: 1,
		WeatherType.Rainy: 0.8,
		WeatherType.Stormy: 1,
		WeatherType.Snowy: 0.2
	}[weather_type]


static func get_weather_raininess(weather_type: WeatherType) -> float:
	return {
		WeatherType.Sunny: 0,
		WeatherType.Overcast: 0,
		WeatherType.Rainy: 0.5,
		WeatherType.Stormy: 1,
		WeatherType.Snowy: 0
	}[weather_type]


static func get_weather_snowiness(weather_type: WeatherType) -> float:
	return {
		WeatherType.Sunny: 0,
		WeatherType.Overcast: 0,
		WeatherType.Rainy: 0,
		WeatherType.Stormy: 0,
		WeatherType.Snowy: 1
	}[weather_type]


static func get_weather_lightning_chance(weather_type: WeatherType) -> float:
	return {
		WeatherType.Sunny: 0,
		WeatherType.Overcast: 0,
		WeatherType.Rainy: 0,
		WeatherType.Stormy: 0.05,
		WeatherType.Snowy: 0
	}[weather_type]


static func get_weather_name(weather_type: WeatherType) -> String:
	return {
		WeatherType.Sunny: "sunny",
		WeatherType.Overcast: "overcast",
		WeatherType.Rainy: "rainy",
		WeatherType.Stormy: "stormy",
		WeatherType.Snowy: "snowy"
	}[weather_type]


static func get_weather_min_order_size(weather_type: WeatherType) -> int:
	return {
		WeatherType.Sunny: 1,
		WeatherType.Overcast: 2,
		WeatherType.Rainy: 1,
		WeatherType.Stormy: 1,
		WeatherType.Snowy: 1
	}[weather_type]


static func get_weather_max_order_size(weather_type: WeatherType) -> int:
	return {
		WeatherType.Sunny: 3,
		WeatherType.Overcast: 3,
		WeatherType.Rainy: 2,
		WeatherType.Stormy: 2,
		WeatherType.Snowy: 2
	}[weather_type]


static func get_weather_item_weighting(weather_type: WeatherManager) -> Dictionary[Menu.Item, float]:
	return {
		WeatherType.Sunny: {
			Menu.Item.HamBurger: 1,
			Menu.Item.Fries: 1,
			Menu.Item.Soda: 2.5
		},
		WeatherType.Overcast: {
			Menu.Item.HamBurger: 1.5,
			Menu.Item.Fries: 1,
			Menu.Item.Soda: 0.8
		},
		WeatherType.Rainy: {
			Menu.Item.HamBurger: 1,
			Menu.Item.Fries: 1,
			Menu.Item.Soda: 0.8
		},
		WeatherType.Stormy: {
			Menu.Item.HamBurger: 1,
			Menu.Item.Fries: 2,
			Menu.Item.Soda: 0.5
		},
		WeatherType.Snowy: {
			Menu.Item.HamBurger: 1,
			Menu.Item.Fries: 1,
			Menu.Item.Soda: 0.2
		}
	}[weather_type]
