shader_type canvas_item;

uniform vec3 player_color;

void fragment() {
	vec2 coords = vec2((UV.x-0.5)*2.0, UV.y);

	float alpha = float(abs(coords.x) - coords.y < 0.0);
	COLOR = vec4(player_color, alpha);
}

