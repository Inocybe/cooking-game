shader_type spatial;
render_mode unshaded;

uniform vec3 color: source_color;
uniform float bloom;

uniform sampler2D noise_x;
uniform sampler2D noise_y;

uniform float offset_scale;

void vertex() {
	float height = VERTEX.y;
	float x_offset = texture(noise_x, vec2(height)).r;
	float y_offset = texture(noise_y, vec2(height)).r;
	VERTEX += vec3(x_offset, 0, y_offset) * offset_scale;
}

void fragment() {
	ALBEDO = color * bloom;
}
