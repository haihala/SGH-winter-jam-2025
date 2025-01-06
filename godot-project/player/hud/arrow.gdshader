shader_type canvas_item;


void fragment() {
	vec2 coords = 2.0*(UV - 0.5);
	COLOR = vec4(0.0);

	// Shaft
	if (abs(coords.y) < 0.05 && coords.x > -0.2 && coords.x < 0.8) {
		COLOR.a = 1.0;
	}

	// Head
	if (coords.x > 0.6 && abs(1.5 * coords.y) < (1.0-coords.x)) {
		COLOR.a = 1.0;
	}
}