extends Button

@export var forcast_length: int = 0

func _ready() -> void:
	var day = forcast_length + ProgressManager.day
	text = "Day: " + str(day)
