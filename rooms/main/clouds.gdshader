shader_type canvas_item;
uniform sampler2D noise_tex : repeat_enable, filter_nearest;
uniform float pixel_size=0.01;

void fragment() {
	vec2 pixelization = floor(UV/pixel_size)*pixel_size;

	float noise = texture(noise_tex, pixelization + (TIME / 100.0f)).r;
	float fog = clamp(noise * 1.8 - 1.0, 0.0 ,1.0);
	COLOR.a = fog;
}
