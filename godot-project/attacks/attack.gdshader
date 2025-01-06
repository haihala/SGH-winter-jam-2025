shader_type canvas_item;

uniform vec3 player_color;

const float pixel_count = 4.0;

void fragment() {
	vec2 coords = (UV - 0.5) * 2.0;

	if (length(coords) > 0.8) {
		COLOR = vec4(0.0);
	}
	else if (length(coords) > 0.4) {
		COLOR = vec4(1.0, 0.0, 0.0, 1.0);
	}
	else {
		COLOR = vec4(player_color, 1.0);
	}
}