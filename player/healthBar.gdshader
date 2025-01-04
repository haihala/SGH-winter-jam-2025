shader_type canvas_item;

uniform int max_health;
uniform int current_health;
uniform vec3 full_color;
uniform vec3 almost_full_color;
uniform vec3 empty_color;

const float GAP_THICKNESS = 0.1;

void fragment() {
	if (current_health == max_health) {
		COLOR.rgb = full_color;
	} else if (current_health == 1) {
		COLOR.rgb = empty_color;
	} else {
		float t = float(current_health) / float(max_health - 1);
		COLOR.rgb = t * almost_full_color + (1.0-t) * empty_color;
	}

	vec2 coords = 2.0*(UV - 0.5);

	// Ring
	if (abs(length(coords) - 0.85) > 0.15) {
		COLOR.a = 0.0;
	}

	// Segments
	float ang = atan(coords.x, coords.y) + PI;
	float segment_width = 2.0*PI/float(max_health);
	// Top gap
	if (ang < GAP_THICKNESS || abs(ang-2.0*PI) < GAP_THICKNESS) {
		COLOR.a = 0.0;
	}

	for (int segment = 0; segment < max_health; segment++) {
		float target_ang = float(segment)*segment_width;
		
		if (abs(ang-target_ang) < GAP_THICKNESS) {
			COLOR.a = 0.0;
		}
	}

	if (ang < float(max_health - current_health) * segment_width) {
		COLOR.a = 0.0;
	}
}
