shader_type canvas_item;

void fragment() {
	vec4 texture = texture(SCREEN_TEXTURE, SCREEN_UV);
	
	vec4 new_color = texture / 100.0;
	
	COLOR = new_color;
}
