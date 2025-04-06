shader_type spatial;
render_mode unshaded;

uniform vec2 UV_offset;

uniform float curvature_factor = 20;
uniform vec2 curvature_center = vec2(0.5, 0.5);

uniform sampler2D color_noise;
uniform float color_noise_scale;

uniform float bump_size = 12.0;

uniform float high_noise_weight = 1.0;
uniform float high_noise_scale = 1.0;
uniform vec2 high_noise_velocity;
uniform sampler2D bump_high_noise;

uniform float low_noise_weight = 1.0;
uniform float low_noise_scale = 0.5;
uniform vec2 low_noise_velocity;
uniform sampler2D bump_low_noise;

uniform float transparent_cutoff;

uniform float max_thickness_damp;

varying float bump;

void vertex() {
	vec2 shifted_UV = UV_offset + UV;

	vec2 high_offset = high_noise_velocity * TIME;
	vec2 high_pos = (shifted_UV + high_offset) * high_noise_scale;
	float raw_bump_high = texture(bump_high_noise, high_pos).x;
	float bump_high = raw_bump_high * high_noise_weight;

	vec2 low_offset = low_noise_velocity * TIME;
	vec2 low_pos = (shifted_UV + low_offset) * low_noise_scale;
	float raw_bump_low = texture(bump_low_noise, low_pos).x;
	float bump_low = raw_bump_low * low_noise_weight;

	float curvature = distance(shifted_UV, curvature_center) * curvature_factor;

	bump = (bump_high + bump_low) / (high_noise_weight + low_noise_weight);
	VERTEX += vec3(0, bump * bump_size + curvature, 0);
}

void fragment() {
	vec2 shifted_UV = UV_offset + UV;
	float brightness_damp = 1.0 - bump * max_thickness_damp;
	vec2 high_offset = high_noise_velocity * TIME;
	vec2 color_pos = (shifted_UV + high_offset) * color_noise_scale;
	vec3 color_value = texture(color_noise, color_pos).rgb;

	ALBEDO = color_value * brightness_damp;
	ALPHA = bump > transparent_cutoff ? 255.0 : 0.0;
	ALPHA_SCISSOR_THRESHOLD = 1.0;
}
