shader_type canvas_item;

uniform float progress : hint_range(0, 1);
uniform bool fill = false;

void vertex() {
    // Called for every vertex the material is visible on.
}

void fragment() {
    float x = abs(pow((UV.x * PI - 0.5 * PI), 2) / SCREEN_PIXEL_SIZE.x);
    float y = abs(pow((UV.y * PI - 0.5 * PI), 2) / SCREEN_PIXEL_SIZE.y);

	float progX = progress*PI/SCREEN_PIXEL_SIZE.x;
	float progY = progress*PI/SCREEN_PIXEL_SIZE.y;
    if ((x + y) > (progX + progY)){
        if (fill) {
            discard;
        }
    } else if (!fill) {
        discard;
    }
}
