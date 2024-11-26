shader_type canvas_item;

uniform float progress : hint_range(0,1);
uniform float diamondSize = 40.0;
uniform bool fill = true;
void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	float x = abs(fract(FRAGCOORD.x/diamondSize) - 0.5);
	float y = abs(fract(FRAGCOORD.y/diamondSize) - 0.5);

	if (x + y + UV.x > progress * 2.0){
		if (fill){
			discard;
		}
	}
	else if (!fill){
		discard;
	}
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
