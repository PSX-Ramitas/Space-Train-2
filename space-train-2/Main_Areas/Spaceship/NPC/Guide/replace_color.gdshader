shader_type canvas_item;

uniform vec4 original_0: source_color;
uniform vec4 original_1: source_color;
uniform vec4 original_2: source_color;
uniform vec4 original_3: source_color;

uniform vec4 replace_0: source_color;
uniform vec4 replace_1: source_color;
uniform vec4 replace_2: source_color;
uniform vec4 replace_3: source_color;

const float precision = 0.1;

vec4 replace_color(vec4 color) {
	vec4 original_colors[4] = vec4[4](original_0, original_1, original_2, original_3);
	vec4 replace_colors[4] = vec4[4](replace_0, replace_1, replace_2, replace_3);
	
	for(int i =0; i < 4; i++){
		if(distance(color, original_colors[i]) <= precision){
			color = replace_colors[i];
		}
	}
	
	return color;
}

void fragment() {
	// Called for every pixel the material is visible on.
	COLOR = replace_color(texture(TEXTURE, UV));
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
