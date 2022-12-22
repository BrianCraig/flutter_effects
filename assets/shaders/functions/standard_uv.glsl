#include <flutter/runtime_effect.glsl>

vec2 uv_transofrmed_square_ratio() {
    //  Center the UV to x: [-.5, .5], y: [-.5, .5]
    vec2 uv = FlutterFragCoord() / i_resolution - 0.5;

    // multiply by projection matrix
    return (vec4(uv.x, uv.y, 0.0, 1.0) * i_transformation).xy;
}

vec2 uv_transofrmed_conserve_x() {
    //  Center the UV to x: [-.5, .5], y: [-.5, .5]
    vec2 uv = FlutterFragCoord() / i_resolution - 0.5;

    // fix aspect ratio, conserving x and stretching y
    uv.y = uv.y * i_resolution.y / i_resolution.x;

    // multiply by projection matrix
    return (vec4(uv.x, uv.y, 0.0, 1.0) * i_transformation).xy;
}

vec2 uv_transofrmed_conserve_y() {
    //  Center the UV to x: [-.5, .5], y: [-.5, .5]
    vec2 uv = FlutterFragCoord() / i_resolution - 0.5;

    // fix aspect ratio, conserving y and stretching x
    uv.x = uv.x * i_resolution.x / i_resolution.y;

    // multiply by projection matrix
    return (vec4(uv.x, uv.y, 0.0, 1.0) * i_transformation).xy;
}