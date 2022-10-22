shader_type canvas_item;

vec3 checker(vec2 uv){
    return vec3(abs(floor(mod(uv.x*10.,2.))-floor(mod(uv.y*10.,2.))));   
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = SCREEN_UV.xy*2;

    //------------------------------------------------
    // To use in Godot, port this section:
    //------------------------------------------------

    // I picked these somewhat arbitrarily
    const float BARREL = -1.0;
    const float PINCUSHION = 0.1;

    float effect = PINCUSHION; // Set effect to either BARREL or PINCUSHION
    float effect_scale = 1.0;  // Play with this to slightly vary the results

    /// Fisheye Distortion ///
    float d=length(uv);
    float z = sqrt(1.0 + d * d * effect);
    float r = atan(d, z) / 3.14159;
    r *= effect_scale;
    float phi = atan(uv.y, uv.x);

    uv = vec2(r*cos(phi)+.5,r*sin(phi)+.5);

    //------------------------------------------------
    // end relevant logic
    //------------------------------------------------

    fragColor = vec4(checker(uv),1.);
}