shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform float grain_strength : hint_range(0.0, 0.8) = 0.1;

float random(vec2 uv) {
    return fract(sin(dot(uv, vec2(12.9898,78.233))) * 43758.5453);
}

void fragment() {
    vec2 uv = SCREEN_UV;
    vec4 col = texture(SCREEN_TEXTURE, uv);

    float noise = random(uv + TIME);
    col.rgb += (noise - 0.5) * grain_strength;

    COLOR = col;
}