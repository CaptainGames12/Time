shader_type canvas_item;

uniform float freeze_amount : hint_range(0.0, 1.0) = 0.0;
uniform sampler2D noise_texture : hint_default_white;

void fragment() {
	vec4 tex_color = texture(TEXTURE, UV);

	// Отримуємо шум (для кристалізації/порушення поверхні)
	vec2 noise_uv = UV * 10.0;
	float noise = texture(noise_texture, noise_uv).r;

	// Кристалізація — чим більше freeze_amount, тим більше спотворення кольору
	vec3 frozen_color = mix(tex_color.rgb, vec3(0.6, 0.8, 1.0), 0.7); // Холодний блакитний

	// Додаємо ефект "інею" (легке збілення + noise)
	float frost = smoothstep(0.4, 1.0, noise + freeze_amount * 0.5);
	vec3 final_color = mix(tex_color.rgb, frozen_color, freeze_amount);
	final_color = mix(final_color, vec3(1.0), frost * freeze_amount * 0.5); // легкий білий відтінок

	COLOR = vec4(final_color, tex_color.a);
}
