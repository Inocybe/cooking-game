shader_type spatial;

uniform vec3 min_base_color: source_color;
uniform vec3 max_base_color: source_color;

uniform sampler2D grain_noise_high;
uniform float high_noise_scale;
uniform float high_noise_weight;

uniform sampler2D grain_noise_low;
uniform float low_noise_scale;
uniform float low_noise_weight;

void fragment() {
	vec4 pos = inverse(MODEL_MATRIX) * (INV_VIEW_MATRIX * vec4(VERTEX, 1));

	vec2 high_noise_pos = pos.xz * high_noise_scale;
	float high_noise_val = texture(grain_noise_high, high_noise_pos).r;

	vec2 low_noise_pos = pos.xz * low_noise_scale;
	float low_noise_val = texture(grain_noise_low, low_noise_pos).r;

	float noise_val = (
		high_noise_val * high_noise_weight
		+ low_noise_val * low_noise_weight
	) / (high_noise_weight + low_noise_weight);

	ALBEDO = mix(min_base_color, max_base_color, noise_val);
}
