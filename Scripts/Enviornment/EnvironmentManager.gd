class_name EnvironmentManager extends WorldEnvironment


@export var max_fog_density: float = 0.01
@export var max_fog_sky_affect: float = 1


func set_raininess(raininess: float):
	if raininess > 0:
		environment.fog_enabled = true
		environment.fog_density = max_fog_density * raininess
		environment.fog_sky_affect = max_fog_sky_affect * raininess
	else:
		environment.fog_enabled = false
