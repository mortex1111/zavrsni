shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

uniform float contrast : hint_range(0.0, 8.0) = 1.6;
uniform float vignette_strength : hint_range(0.0, 2.0) = 1.0;
uniform float grain_strength : hint_range(0.0, 0.8) = 2.5;

float random(vec2 uv) {
    return fract(sin(dot(uv, vec2(12.9898,78.233))) * 43758.5453);
}

void fragment() {
    vec2 uv = SCREEN_UV;
    vec4 col = texture(SCREEN_TEXTURE, uv);

    // Contrast
    col.rgb = (col.rgb - 0.5) * contrast + 0.5;

    // Vignette
    float dist = distance(uv, vec2(0.5));
    float vignette = smoothstep(0.75, 0.35, dist);
    col.rgb *= vignette;

    // Grain
    float noise = random(uv + TIME);
    col.rgb += (noise - 0.5) * grain_strength;

    COLOR = col;
}