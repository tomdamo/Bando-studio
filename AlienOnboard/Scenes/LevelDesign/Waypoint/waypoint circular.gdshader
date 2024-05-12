shader_type spatial;

uniform vec3 color:source_color; 
uniform float density:hint_range(0.0, 1.0, 0.01); 
uniform float radial_res:hint_range(1, 40, 1); 
uniform float angular_res:hint_range(1, 40, 1); 
uniform float line_space:hint_range(0.0, 1.0, 0.01); 
uniform float revolutions;
uniform float emission:hint_range(0.0, 20.0, 0.01); 

float circle(vec2 uv, float diameter, float feather)
{
    float radius = diameter/2.0;
    return smoothstep(radius, radius + feather, length(uv - vec2(0.5)));
}
vec2 polar_coordinates(vec2 uv, vec2 center)
{
    vec2 dir = uv - center;
    float radius = length(dir) * 2.0;
    float angle = atan(dir.y, dir.x) / TAU; 
    return (vec2(radius, angle)); 
}
float random (vec2 st) {
    return fract(sin(dot(st.xy,
                      vec2(12.9898,78.233))) * 43758.5453123);
}
float randomf(float x){
	return fract(sin(x) * 100000.0); 
}
void fragment() {    
    vec2 res = vec2(radial_res,angular_res); 	
    vec2 uv = polar_coordinates(UV,vec2(0.5)); 
    vec2 igrid = floor(fract(uv)*res);
    vec2 uv2 = polar_coordinates(UV,vec2(0.5)); 
    uv2.y -= revolutions * (randomf(igrid.x)+0.1); 
    vec2 igrid2 = floor(fract(uv2)*res)/res;	
    vec2 fgrid = fract(uv2*res);
    float vsmask = step(line_space, fgrid.x);  
    float rnd = random(igrid2); 	
    float val = float(rnd > (1.0 - density)); 
    float cmask = 1.0 - circle(UV,1.0,0.0); 	
    ALBEDO = color; 
    EMISSION = color * emission; 
    ALPHA = val*vsmask*cmask;
}