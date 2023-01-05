float source_hash(vec2 i);
vec2 source_hash(vec2 i);
float source_hash(vec3 i);
vec3 source_hash(vec3 i);

// bilinear interpolation that uses vec2 hashes
float interpolation_simple(vec2);
// dot bilinear interpolation that uses vec2 hashes
float interpolation_dot(vec2);

// trilinear interpolation that uses float hashes
float interpolation_simple(vec3);
// dot trilinear interpolation that uses vec3 hashes
float interpolation_dot(vec3);

#ifndef INTERPOLATION
#define INTERPOLATION interpolation_dot
#endif

// noise without smoothing (faster)
float simple_noise(vec2 i){
    return INTERPOLATION(i);
};

// noise with smoothing (multiple layers with different weights) (slower)
float smooth_noise(vec2 i);

// noise without smoothing (faster)
float simple_noise(vec3 i){
    return INTERPOLATION(i);
};

// noise with smoothing (multiple layers with different weights) (slower)
float smooth_noise(vec3 i);
