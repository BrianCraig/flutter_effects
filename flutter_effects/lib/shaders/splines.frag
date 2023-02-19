#version 460 core

precision highp float;

#include <flutter/runtime_effect.glsl>

#include <functions/standard_uniforms.glsl>

#include <functions/transform2d_uniforms.glsl>

#include <functions/time_uniforms.glsl>

uniform vec4 i_color_background;
uniform vec4 i_color_line;

const float PIXEL_SIZE = 32;

float noise(vec2 p) {
    p = 50.0 * fract(p * 0.3183099 + vec2(0.71, 0.113));
    return fract(p.x * p.y * (p.x + p.y));
}

float point_from_pos(vec2 pos, float unit) {
    return noise(vec2(floor(pos.x) - 1 + unit, floor(pos.y)));
}

float cubic_interpolate(float x0, float x1, float x2, float x3, float t) {
    float a = (3.0 * x1 - 3.0 * x2 + x3 - x0) / 2.0;
    float b = (2.0 * x0 - 5.0 * x1 + 4.0 * x2 - x3) / 2.0;
    float c = (x2 - x0) / 2.0;
    float d = x1;

    return a * t * t * t +
        b * t * t +
        c * t +
        d;
}

void main() {
    vec2 position = uv_transform2d() / (PIXEL_SIZE * i_dpr);
    float a = point_from_pos(position, 0);
    float b = point_from_pos(position, 1);
    float c = point_from_pos(position, 2);
    float d = point_from_pos(position, 3);
    float interpolation = cubic_interpolate(a, b, c, d, fract(position.x)) *.8 +.1;
    float di = distance(interpolation, fract(position.y));
    fragColor = mix(i_color_line, i_color_background, smoothstep(0, 1, floor(di*PIXEL_SIZE)));
}