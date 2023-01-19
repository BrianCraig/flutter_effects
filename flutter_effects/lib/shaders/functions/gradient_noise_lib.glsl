float source_hash_v1(vec2 i, vec2 dot) {
    i = 50.0 * fract(i * 0.3183099 + dot);
    return -1.0 + 2.0 * fract(i.x * i.y * (i.x + i.y));
};

float source_hash_v1(vec2 i) {
    return source_hash_v1(i, vec2(0.71, 0.113));
};


vec2 source_hash_v2(vec2 i){
    float v1 = source_hash_v1(i, vec2(0.71, 0.113));
    float v2 = source_hash_v1(i, vec2(269.5,183.3));
    return vec2(v1, v2);
};

float source_hash_v1(vec3 i);
vec3 source_hash_v3(vec3 i);

// bilinear interpolation that uses vec2 hashes
float interpolation_simple(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);

    vec2 u = smoothstep(0, 1, f);

    float x0y0 = source_hash_v1(i + vec2(0.0, 0.0));
    float x1y0 = source_hash_v1(i + vec2(1.0, 0.0));
    float x0y1 = source_hash_v1(i + vec2(0.0, 1.0));
    float x1y1 = source_hash_v1(i + vec2(1.0, 1.0));

    float val =  mix(mix(x0y0, x1y0, u.x), mix(x0y1, x1y1, u.x), u.y);
    return smoothstep(-1, 1, val);
};
// dot bilinear interpolation that uses vec2 hashes
float interpolation_dot(vec2 p){
    vec2 i = floor(p);
    vec2 f = fract(p);

    vec2 u = smoothstep(0, 1, f);

    //dot( hash( i + vec3(0.0,0.0,0.0) ), f - vec3(0.0,0.0,0.0)

    float x0y0 = dot(source_hash_v2(i + vec2(0.0, 0.0)), f - vec2(0.0, 0.0));
    float x1y0 = dot(source_hash_v2(i + vec2(1.0, 0.0)), f - vec2(1.0, 0.0));
    float x0y1 = dot(source_hash_v2(i + vec2(0.0, 1.0)), f - vec2(0.0, 1.0));
    float x1y1 = dot(source_hash_v2(i + vec2(1.0, 1.0)), f - vec2(1.0, 1.0));

    float val =  mix(mix(x0y0, x1y0, u.x), mix(x0y1, x1y1, u.x), u.y);
    return smoothstep(-1, 1, val);
};

// trilinear interpolation that uses float hashes
float interpolation_simple(vec3);
// dot trilinear interpolation that uses vec3 hashes
float interpolation_dot(vec3);

#ifndef INTERPOLATION
#define INTERPOLATION interpolation_dot
#endif

// noise without smoothing (faster)
float straight_noise(vec2 i) {
    return INTERPOLATION(i);
};

// noise with smoothing (multiple layers with different weights) (slower)
float smooth_noise(vec2 i);

// noise without smoothing (faster)
float straight_noise(vec3 i) {
    return INTERPOLATION(i);
};

// noise with smoothing (multiple layers with different weights) (slower)
float smooth_noise(vec3 i);
