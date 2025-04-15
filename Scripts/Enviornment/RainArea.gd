class_name RainArea extends Node3D


var heavy_raininess_cutoff: float = 0.75
var medium_raininess_cutoff: float = 0.25


func set_raininess(raininess: float) -> void:
	$GPUParticles3D.amount_ratio = raininess
	
	var is_rain_heavy = raininess > heavy_raininess_cutoff
	var is_rain_medium = raininess > medium_raininess_cutoff and not is_rain_heavy
	
	if is_rain_heavy:
		$HeavyRainSoundFader.fade_in()
	else:
		$HeavyRainSoundFader.fade_out()
	
	if is_rain_medium:
		$MediumRainSoundFader.fade_in()
	else:
		$MediumRainSoundFader.fade_out()
