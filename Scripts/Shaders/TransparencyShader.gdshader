shader_type spatial;
render_mode depth_prepass_alpha;

uniform float transparency_min: hint_range(0.0, 1.0) = 0.2; // min transparency
uniform float transparency_max: hint_range(0.0, 1.0) = 0.7; // max transparency
uniform float speed = 5.0; //speed of fluctiation


void fragment() {
	float time_factor = sin(TIME * speed) * 0.5 + 0.5;
	float fluctuating_alpha = mix(transparency_min, transparency_max, time_factor);

	ALPHA = fluctuating_alpha;
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
