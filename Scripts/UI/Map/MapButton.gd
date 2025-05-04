@tool
class_name MapButton extends Control


signal world_load_requested()

const ICON = preload("res://Scenes/ui/icon.tscn")

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var label: RichTextLabel = %Text

@export var town: TownResource
@export var position_fraction: Vector2

var icons: Array[Control]


func _ready() -> void:
	get_parent().resized.connect(reposition)
	reposition()
	
	$ShowButton.text = " "+town.name+" "


func init_town() -> void:
	town.random_forcast(ProgressManager.day)
	show_town_values(0)


func reposition() -> void:
	position = position_fraction * get_parent().size


func on_show_pressed() -> void:
	animation_player.play("display_town_values")


func on_go_pressed() -> void:
	Global.town = town
	
	world_load_requested.emit()


func show_town_values(day: int) -> void:
	var weather_name = WeatherManager.get_weather_name(town.weather_forcast[day])
	label.text = """Weather: %s
Temperature: %.2f°C
Population: %d
Opening hours: %.f hours""" % [
		weather_name, town.temp_forcast[day], town.population, town.opening_hours
	]
