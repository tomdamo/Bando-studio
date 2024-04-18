shader_type spatial;

void fragment() {
    // Set the base color of the planet
    vec3 base_color = vec3(1.0, 0.5, 0.8); 

    // Calculate the lighting intensity
    float light_intensity = max(dot(normalize(-vec3(6.0, 1.9, 0.7)), NORMAL), 0.0);

    // Combine base color with lighting intensity
    vec3 final_color = base_color * light_intensity;

    // Output final color
    ALBEDO = final_color;
}
