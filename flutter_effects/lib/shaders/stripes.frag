#version 460 core

precision highp float;

#include <flutter/runtime_effect.glsl>

#include <functions/standard_uniforms.glsl>

#include <functions/transform2d_uniforms.glsl>

#include <functions/time_uniforms.glsl>

#include <functions/simplex/open_simplex_2_s.glsl>

uniform vec4 i_color_background;
uniform vec4 i_color_line;

const float PIXEL_SIZE = 32;

const float NUM_STRIPES = 21;

#define PI 3.1415926538

float clamp_multiplied(float x, float edge, float mul) {
    return clamp(x * mul - edge * mul + .5, 0, 1);
}

float stripes(float x) {
    return (cos(x*PI) *.5 + cos(x*PI*NUM_STRIPES)) / 1.5;
}

void main() {
    vec2 position = uv_transform2d() / (PIXEL_SIZE * i_dpr);
    float noise = openSimplex2SDerivatives_ImproveXY(vec3(position, i_time)).w;
    float stripe = clamp_multiplied(stripes(noise), 0, 350);
    fragColor = mix(i_color_background, i_color_line, stripe);
}