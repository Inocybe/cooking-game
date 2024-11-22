shader_type spatial;
render_mode unshaded;

uniform vec4 center_color: source_color = vec4(1, 1, 1, 1);
uniform vec4 edge_color: source_color = vec4(0, 0, 0, 0.9);
uniform float degrees_to_fade_alpha_50: hint_range(0.0, 90.0) = 30;
uniform float degrees_to_fade_color_50: hint_range(0.0, 90.0) = 30;

void fragment() {
	float angle_to_camera = asin(dot(NORMAL, normalize(VERTEX)));
	float camera_angle_t = abs(angle_to_camera / (PI / 2.0));
	float color_m = log(0.5) / log(degrees_to_fade_color_50 / 90.0);
	float color_fade = pow(camera_angle_t, color_m);
	float alpha_m = log(0.5) / log(degrees_to_fade_alpha_50 / 90.0);
	float alpha_fade = pow(camera_angle_t, alpha_m);
    ALBEDO = mix(edge_color.rgb, center_color.rgb, color_fade);
	ALPHA = mix(edge_color.a, center_color.a, alpha_fade);
}
