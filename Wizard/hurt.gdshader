shader_type canvas_item;

uniform float flash_strength : hint_range(0.0, 1.0) = 0.0;

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);

    // Червоний спалах
    vec3 red_flash = vec3(1.0, 0.0, 0.0);

    // Змішуємо оригінальний колір з червоним залежно від flash_strength
    tex_color.rgb = mix(tex_color.rgb, red_flash, flash_strength);

    COLOR = tex_color;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
