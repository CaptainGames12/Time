shader_type canvas_item;

uniform float enabled = 1.0;
uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap;
void fragment() {
    vec4 tex_color = texture(SCREEN_TEXTURE, SCREEN_UV);
    float gray = dot(tex_color.rgb, vec3(0.299, 0.587, 0.114));
    vec3 final_color = mix(tex_color.rgb, vec3(gray), enabled);
    COLOR = vec4(final_color, tex_color.a);
}