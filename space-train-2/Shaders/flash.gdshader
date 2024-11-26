shader_type canvas_item;

uniform float flash_intensity : hint_range(0.0, 1.0) = 0.0; // Adjust between 0 (no flash) and 1 (full flash)

void fragment() {
    vec4 texture_color = texture(TEXTURE, UV);
    
    // Mix between the texture color and white based on flash_intensity
    vec4 flash_color = vec4(1.0, 1.0, 1.0, texture_color.a);
    COLOR = mix(texture_color, flash_color, flash_intensity);
}
