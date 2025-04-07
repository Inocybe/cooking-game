shader_type spatial;
render_mode unshaded;

uniform vec4 color: source_color;

uniform float squish_height;
uniform float floor_y;
uniform float max_squish;
uniform float x_squash;

void vertex() {
	float floor_dist = NODE_POSITION_WORLD.y - floor_y;
	float squish = clamp(1.0 - floor_dist / squish_height, 0.0, max_squish);
	VERTEX.y *= 1.0 - squish;
	float x_scale = 1.0 + squish * x_squash;
	VERTEX.x *= x_scale;
	VERTEX.z *= x_scale;
}

void fragment() {
	ALBEDO = color.rgb;
	ALPHA = color.a * COLOR.a;
}
