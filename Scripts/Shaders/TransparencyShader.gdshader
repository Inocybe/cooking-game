shader_type spatial;

uniform float transparency_min: hint_range(0.0, 1.0) = 0.2; // min transparency
uniform float transparency_max: hint_range(0.0, 1.0) = 0.7; // max transparency
uniform float speed = 5.0; //speed of fluctiation


void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	float time_factor = sin(TIME * speed) * 0.5 + 0.5;
	float fluctuating_alpha = mix(transparency_min, transparency_max, time_factor);

	// set materials alpha to fluctuate
	ALPHA = fluctuating_alpha;
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
