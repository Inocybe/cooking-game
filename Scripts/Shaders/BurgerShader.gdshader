shader_type spatial;

uniform vec3 base_color: source_color;

uniform sampler2D uncooked_noise_texture;
uniform float uncooked_noise_scale;

uniform sampler2D cooked_noise_texture;
uniform float cooked_noise_scale;

uniform float cooked_amount;

void fragment() {
	vec4 pos = inverse(MODEL_MATRIX) * (INV_VIEW_MATRIX * vec4(VERTEX, 1));
	ALBEDO = base_color;
	float cooked_fraction = min(cooked_amount, 1.0);
	vec3 uncooked_noise = texture(uncooked_noise_texture, pos.xz * uncooked_noise_scale).rgb;
	ALBEDO += uncooked_noise * (1.0 - cooked_fraction);
	vec3 cooked_noise = texture(cooked_noise_texture, pos.xz * cooked_noise_scale).rgb;
	ALBEDO += cooked_noise * cooked_fraction;
}
