extends MeshInstance3D


@export var lifetime: float = 1
@export var min_sound_delay: float = 0.5
@export var max_sound_delay: float = 1

var age_frac: float = 0
var material: ShaderMaterial


func _ready() -> void:
	material = get_surface_override_material(0)
	randomize_noise(material.get_shader_parameter("noise_x"))
	randomize_noise(material.get_shader_parameter("noise_y"))
	
	$SoundDelayTimer.start(randf_range(min_sound_delay, max_sound_delay))


func randomize_noise(texture: NoiseTexture2D):
	texture.noise.seed = randi()


func _process(delta: float) -> void:
	age_frac += delta / lifetime
	if age_frac > 1:
		visible = false
	material.set_shader_parameter("age_frac", age_frac)


func start_audio() -> void:
	return
	
	$ThunderPlayer.play()


func audio_finished() -> void:
	queue_free()
