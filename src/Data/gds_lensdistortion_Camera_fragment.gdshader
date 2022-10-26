shader_type canvas_item;


void fragment(){
	vec4 screen_texture = texture(SCREEN_TEXTURE, SCREEN_UV);
	
	vec2 new_uv = round(SCREEN_UV * 240.0)/ 240.0;
	
	vec4 new_screen_texture = texture(SCREEN_TEXTURE, new_uv);
	
	// new_screen_texture.rg = vec2(new_screen_texture.b);
	
	COLOR = round(new_screen_texture * vec4(2.0, 2.0, 15.0, 1.0)) / vec4(2.0, 2.0, 15.0, 1.0);
}