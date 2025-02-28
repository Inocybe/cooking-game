extends Button

@onready var resource: town = town.new()

func generate_town_values() -> void:
	resource.random_everything()
