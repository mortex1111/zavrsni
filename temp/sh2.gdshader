shader_type canvas_item;

// Thickness of the lines
uniform float thickness : hint_range(0.5, 10.0, 0.1) = 2.0;

// Edge sensitivity (how much of the image counts as "line")
uniform float threshold : hint_range(0.0, 1.0, 0.01) = 0.5;

// Smoothness of edges
uniform float softness : hint_range(0.0, 1.0, 0.01) = 0.1;

// Line color
uniform vec4 line_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);

void fragment() {
    vec4 tex = texture(TEXTURE, UV);

    // Convert to grayscale (detect brightness)
    float gray = dot(tex.rgb, vec3(0.299, 0.587, 0.114));

    // Detect dark lines (invert if needed)
    float line_mask = 1.0 - gray;

    // Screen-space thickness correction
    float w = fwidth(line_mask) * thickness;

    // Create thicker/smoother lines
    float line = smoothstep(threshold - w - softness,
                            threshold + w + softness,
                            line_mask);

    // Output
    COLOR.rgb = line_color.rgb;
    COLOR.a = line * tex.a * line_color.a;
}