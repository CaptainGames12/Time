shader_type canvas_item;
uniform sampler2D noise_tex : repeat_enable, filter_nearest;
varying vec2 world_position;
uniform float scale = 0.000944444;
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
const float color_triger = 111.0f / 256.0f;
const vec4 color_mix = vec4(72.0f / 256.0f, 106.0f / 256.0f, 36.0f / 256.0f,1);

void vertex(){
	world_position = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
}

float color_remover(float noise_color) {
    if(noise_color > 0.5f) {
      return 0.0f;
    } else {
      return 1.0f;
    }
}

void fragment() {
	vec4 tex = texture(TEXTURE, UV);

	if(tex.g < 0.49459375f) {
		vec4 noise = texture(noise_tex, world_position * scale);

		COLOR = mix(tex, color_mix, color_remover(noise.r));
	} else {
		COLOR = tex;
	}

}
