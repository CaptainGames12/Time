shader_type canvas_item;


uniform float intensity : hint_range(0.0, 1.0) = 0.7;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
void fragment() {
    vec2 uv = SCREEN_UV;

    // Волнообразное искажение (пьяная качка)
    float wave = sin(uv.y * 20.0 + TIME * 4.0) * 0.02 * intensity;
    uv.x += wave;

    // Хроматическая аберрация (цветной раздрай)
    float chroma = 0.005 * intensity;
    vec4 col;
    col.r = texture(SCREEN_TEXTURE, uv + vec2(chroma, 0.0)).r;
    col.g = texture(SCREEN_TEXTURE, uv).g;
    col.b = texture(SCREEN_TEXTURE, uv - vec2(chroma, 0.0)).b;
    col.a = 1.0;

    // Размытие по центру (глаза в кучку не собираются)
    float dist = distance(uv, vec2(0.5));
    float blur = smoothstep(0.2, 0.8, dist) * intensity;
    col.rgb = mix(col.rgb, vec3(dot(col.rgb, vec3(0.33))), blur);

    // Лёгкий шум (звон в ушах)
    float noise = (fract(sin(dot(uv * TIME, vec2(12.9898, 78.233))) * 43758.5453) - 0.5) * 0.2 * intensity;
    col.rgb += noise;

	col.rgb *= 10.0;


    COLOR = col;

}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
