shader_type canvas_item;

uniform float glow_strength : hint_range(0.0, 2.0) = 0.8;
uniform vec4 glow_color = vec4(1.0, 1.0, 0.0, 1.0); // yellow
uniform float radius : hint_range(0.0, 1.0) = 0.5;

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);
    
    // Compute distance from center
    vec2 center = vec2(0.5, 0.5);
    float dist = distance(UV, center);
    
    // Glow factor decreases with distance from center
    float glow = smoothstep(radius, 0.0, dist) * glow_strength;
    
    // Mix original color with glow color
    vec4 final_color = mix(tex_color, glow_color, glow * glow_color.a);
    
    // Preserve alpha (you could boost alpha if desired)
    final_color.a = tex_color.a;
    
    COLOR = final_color;
}
