shader_type canvas_item;
uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap;
uniform float progress : hint_range(0.0, 1.0) = 0.0;
uniform vec4 ring_color : source_color = vec4(1.0, 0.6, 0.1, 1.0);
uniform float thickness = 0.05;

// координати центру та нормалізовані UV
void fragment() {
    vec2 uv = UV - vec2(0.5); // центр у (0,0)
    float dist = length(uv);
	vec4 tex_color = texture(SCREEN_TEXTURE, SCREEN_UV);
    float gray = dot(tex_color.rgb, vec3(0.299, 0.587, 0.114));
    vec3 final_color = mix(tex_color.rgb, vec3(gray), 1.0);

    // Радіус кільця відповідно до часу
    float ring_radius = progress;

    // Плавні краї кільця
    float edge = smoothstep(ring_radius - thickness, ring_radius, dist) *
                 (1.0 - smoothstep(ring_radius, ring_radius + thickness, dist));

    COLOR = ring_color * edge * vec4(final_color, tex_color.a) * 2.0;
}