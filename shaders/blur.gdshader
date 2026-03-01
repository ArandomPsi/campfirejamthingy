shader_type canvas_item;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform vec2 dir = vec2(0.0, 0.0);
uniform int quality = 4;

void fragment(){
    // Start with the original screen texture
    vec4 color = texture(SCREEN_TEXTURE, SCREEN_UV);
    vec2 stepSize = dir / float(quality);
    float totalWeight = 1.0;

    for(int i = 1; i <= quality; i++){
        // Positive direction blur
        vec2 offsetUV = SCREEN_UV + stepSize * float(i);
        vec4 sample = texture(SCREEN_TEXTURE, offsetUV);
        color += sample;
        totalWeight += 1.0;

        // Negative direction blur
        offsetUV = SCREEN_UV - stepSize * float(i);
        sample = texture(SCREEN_TEXTURE, offsetUV);
        color += sample;
        totalWeight += 1.0;
    }

    // Average the accumulated color
    COLOR = color / totalWeight;
}
