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

var weather_type: WeatherType = WeatherType.Sunny
var temperature: float = 0


func _ready() -> void:
	var current_scene = get_tree().current_scene
	clouds = current_scene.get_node_or_null("Clouds")
	rain_area = current_scene.get_node_or_null("RainArea")
	snow_area = current_scene.get_node_or_null("SnowArea")
	enviornment = current_scene.get_node_or_null("WorldEnvironment")
	lightning_manager = current_scene.get_node_or_null("LightningManager")


func set_from_town(town: TownResource) -> void:
	weather_type = town.weather_forcast[0]
	temperature = town.temp_forcast[0]
	
	var storminess = get_storminess(weather_type)
	var raininess = get_raininess(weather_type)
	var snowiness = get_snowiness(weather_type)
	var lightning_chance = get_lightning_chance(weather_type)
	
	clouds.set_starting_storminess(storminess)
	rain_area.set_raininess(raininess)
	snow_area.set_snowiness(snowiness)
	enviornment.set_raininess(raininess)
	lightning_manager.set_lightning_chance(lightning_chance)


static func get_storminess(type_: WeatherType) -> float:
	return {
		WeatherType.Sunny: 0,
		WeatherType.Overcast: 1,
		WeatherType.Rainy: 0.8,
		WeatherType.Stormy: 1,
		WeatherType.Snowy: 0.2
	}[type_]


static func get_raininess(type_: WeatherType) -> float:
	return {
		WeatherType.Sunny: 0,
		WeatherType.Overcast: 0,
		WeatherType.Rainy: 0.5,
		WeatherType.Stormy: 1,
		WeatherType.Snowy: 0
	}[type_]


static func get_snowiness(type_: WeatherType) -> float:
	return {
		WeatherType.Sunny: 0,
		WeatherType.Overcast: 0,
		WeatherType.Rainy: 0,
		WeatherType.Stormy: 0,
		WeatherType.Snowy: 1
	}[type_]


static func get_lightning_chance(type_: WeatherType) -> float:
	return {
		WeatherType.Sunny: 0,
		WeatherType.Overcast: 0,
		WeatherType.Rainy: 0,
		WeatherType.Stormy: 0.05,
		WeatherType.Snowy: 0
	}[type_]


static func get_weather_name(type_: WeatherType) -> String:
	return {
		WeatherType.Sunny: "sunny",
		WeatherType.Overcast: "overcast",
		WeatherType.Rainy: "rainy",
		WeatherType.Stormy: "stormy",
		WeatherType.Snowy: "snowy"
	}[type_]


static func get_min_order_size(type_: WeatherType) -> int:
	return {
		WeatherType.Sunny: 1,
		WeatherType.Overcast: 2,
		WeatherType.Rainy: 1,
		WeatherType.Stormy: 1,
		WeatherType.Snowy: 1
	}[type_]


static func get_max_order_size(type_: WeatherType) -> int:
	return {
		WeatherType.Sunny: 3,
		WeatherType.Overcast: 3,
		WeatherType.Rainy: 2,
		WeatherType.Stormy: 2,
		WeatherType.Snowy: 2
	}[type_]


static func get_item_weighting(type_: WeatherType) -> Dictionary:
	return {
		WeatherType.Sunny: {
			Menu.Item.HamBurger: 1.0,
			Menu.Item.Fries: 1.0,
			Menu.Item.Soda: 2.5
		},
		WeatherType.Overcast: {
			Menu.Item.HamBurger: 1.5,
			Menu.Item.Fries: 1.0,
			Menu.Item.Soda: 0.8
		},
		WeatherType.Rainy: {
			Menu.Item.HamBurger: 1.0,
			Menu.Item.Fries: 1.0,
			Menu.Item.Soda: 0.8
		},
		WeatherType.Stormy: {
			Menu.Item.HamBurger: 1.0,
			Menu.Item.Fries: 2.0,
			Menu.Item.Soda: 0.5
		},
		WeatherType.Snowy: {
			Menu.Item.HamBurger: 1.0,
			Menu.Item.Fries: 1.0,
			Menu.Item.Soda: 0.2
		}
	}[type_]


static func get_customer_patience(type_: WeatherType) -> float:
	return {
		WeatherType.Sunny: 60,
		WeatherType.Overcast: 90,
		WeatherType.Rainy: 30,
		WeatherType.Stormy: 20,
		WeatherType.Snowy: 45
	}[type_]


static func get_weather_min_temp(type_: WeatherType) -> float:
	return {
		WeatherType.Sunny: 10,
		WeatherType.Overcast: 0,
		WeatherType.Rainy: 5,
		WeatherType.Stormy: 2,
		WeatherType.Snowy: -10
	}[type_]


static func get_weather_max_temp(type_: WeatherType) -> float:
	return {
		WeatherType.Sunny: 30,
		WeatherType.Overcast: 10,
		WeatherType.Rainy: 15,
		WeatherType.Stormy: 15,
		WeatherType.Snowy: 0
	}[type_]
