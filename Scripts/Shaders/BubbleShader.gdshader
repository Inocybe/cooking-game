shader_type spatial;

uniform sampler3D noise_texture;

uniform vec4 base_color: source_color = vec4(1, 1, 1, 1);

uniform vec4 bubble_color: source_color = vec4(1, 1, 1, 1);

uniform float time_scale = 1;

uniform float bubble_cutoff = 0.8;

uniform float position_scale = 1;

uniform float round_amount = 1;

uniform float max_bubble_radius = 1;

void fragment() {
	vec4 world_vertex = INV_VIEW_MATRIX * vec4(VERTEX, 1.0);
	vec2 surface_pos = vec2(world_vertex.x, world_vertex.z);
	vec2 rounded_surface_pos = round(surface_pos / round_amount) * round_amount;
	vec2 sample_pos = rounded_surface_pos * position_scale + 0.5;
	vec3 sample_xyz = mod(vec3(sample_pos, TIME * time_scale), vec3(textureSize(noise_texture, 0)));
	float raw_noise_value = texture(noise_texture, sample_xyz).r;
	float noise_value = max(raw_noise_value - bubble_cutoff, 0) / (1.0 - bubble_cutoff);
	float bubble_radius = noise_value * max_bubble_radius * round_amount / 2.0;
	float center_dist = length(rounded_surface_pos - surface_pos);
	float mix_amount = center_dist < bubble_radius ? 1.0 : 0.0;
    ALBEDO = mix(base_color.rgb, bubble_color.rgb, mix_amount);
	ALPHA = mix(base_color.a, bubble_color.a, mix_amount);
}
