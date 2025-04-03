shader_type spatial;
render_mode unshaded;

uniform sampler2D color_noise;
uniform float color_noise_scale;

uniform float bump_size;
uniform sampler2D bump_high_noise;
uniform sampler2D bump_low_noise;

uniform float transparent_cutoff;

uniform float max_thickness_damp;

varying float bump;

void vertex() {
	float bump_high = texture(bump_high_noise, UV).x;
	float bump_low = texture(bump_low_noise, UV).x;
	bump = (bump_high + bump_low) / 2.0;
	VERTEX += vec3(0, bump * bump_size, 0);
}

void fragment() {
	float brightness_damp = 1.0 - bump * max_thickness_damp;
	vec3 color_value = texture(color_noise, UV * color_noise_scale).rgb;
	ALBEDO = color_value * brightness_damp;
	ALPHA = bump > transparent_cutoff ? 255.0 : 0.0;
	ALPHA_SCISSOR_THRESHOLD = 1.0;
}
