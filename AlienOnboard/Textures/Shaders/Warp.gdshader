shader_type canvas_item;

uniform vec2 center;  // Center point on UVa coordinates
uniform sampler2D noise;
uniform float sample_radius = 0.5;  // Radius of sampling
uniform vec4 line_color = vec4(1.0);  // Line color with alpha
uniform float center_radius = 0.5;  // Radius of center influence
uniform float fade_amount = 0.0;  // Fade amount (0.0 = fully visible, 1.0 = fully transparent)

const float pi = 3.14159265359;

void fragment() {
    vec2 dist = UV - center;
    float angle = atan(dist.y, dist.x);
    vec2 sample = vec2(sample_radius * cos(angle), sample_radius * sin(angle));
    float noise_value = texture(noise, sample).r;
    vec4 color = mix(line_color, vec4(0.0), noise_value);
    color = mix(color, vec4(0.0), 1.0 - length(dist) - center_radius);
    color.a *= (1.0 - fade_amount);  // Apply fade effect
    COLOR = color;
}