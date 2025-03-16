extends Button

@onready var resource: town = town.new()
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var text_edit: TextEdit = $TextEdit

var displaying: bool = false

func start() -> void:
	resource.random_everything()
	set_town_values()


func _on_pressed() -> void:
	if !displaying:
		animation_player.play("display_town_values")
	else:
		animation_player.play_backwards("display_town_values")



func set_town_values() -> void:
	text_edit.set_line(0, "Weather: " + str(resource.weather))
	text_edit.set_line(1, "Tempurature: " + str(resource.tempurature))
	text_edit.set_line(2, "Population: " + str(resource.population))
