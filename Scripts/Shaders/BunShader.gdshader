shader_type spatial;

uniform sampler2D base_texture;
uniform float base_scale;

uniform sampler2D noise_texture;
uniform float noise_scale;

uniform float brightness_offset;

void fragment() {
	vec4 pos = inverse(MODEL_MATRIX) * (INV_VIEW_MATRIX * vec4(VERTEX, 1));
	ALBEDO = texture(base_texture, pos.xz * base_scale).rgb;
	ALBEDO += texture(noise_texture, pos.xz * noise_scale).rgb;
	ALBEDO += brightness_offset;
}
