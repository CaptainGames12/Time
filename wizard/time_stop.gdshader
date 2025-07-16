shader_type canvas_item;

uniform float progress : hint_range(0.0, 1.0) = 0.0;
uniform vec4 ring_color : source_color = vec4(1.0, 0.6, 0.1, 1.0);
uniform float thickness = 0.05;

// координати центру та нормалізовані UV
void fragment() {
    vec2 uv = UV - vec2(0.5); // центр у (0,0)
    float dist = length(uv);

    // Радіус кільця відповідно до часу
    float ring_radius = progress;

    // Плавні краї кільця
    float edge = smoothstep(ring_radius - thickness, ring_radius, dist) *
                 (1.0 - smoothstep(ring_radius, ring_radius + thickness, dist));

    COLOR = ring_color * edge*2.0;
}