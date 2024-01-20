shader_type canvas_item;

uniform vec4 masking_color : source_color;
uniform vec4 replacement_color: source_color;

uniform float masking_range = 0.1;
uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap;

void fragment() {
	vec4 world_pixel = texture(TEXTURE, UV);
	if (length(abs(masking_color - world_pixel)) <= masking_range)
	{
		COLOR = replacement_color;
	}
	else
	{
		COLOR = world_pixel;
	}
}