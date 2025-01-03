shader_type canvas_item;

const float pixel_count = 4.0;

void fragment() {
	vec2 cent = (UV - 0.5) * 2.0;
	vec2 pixelated = vec2(
		float(int(cent.x * pixel_count)) / pixel_count,
		float(int(cent.y * pixel_count)) / pixel_count
	);
	
	COLOR = vec4(1.0, 0.0, 0.0, float(length(pixelated) < 0.8 ));
}