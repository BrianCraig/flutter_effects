#version 460 core

precision highp float;

#include <flutter/runtime_effect.glsl>

#include <functions/standard_uniforms.glsl>

#include <functions/standard_uv.glsl>

#include <functions/noise.glsl>

layout(location = 3) uniform vec4 i_color_background;
layout(location = 4) uniform vec4 i_color_line;
layout(location = 5) uniform float i_use_smooth;

float fractPerc(float value, float mult, float perc) {
    return step(0.0, perc - fract(value * mult));
}

float fractPercSmooth(float value, float mult, float perc) {
    return smoothstep(0.0, 1.0, perc * 50 - fract(value * mult) * 50);
}

void main() {
    vec2 uv = uv_transofrmed_conserve_x();

    float noise_vec3_smooth = noise_smooth(vec3(uv.x, uv.y, i_time));
    float xx = i_use_smooth >= 1.0 ? fractPercSmooth(noise_vec3_smooth, 15, 0.05) : fractPerc(noise_vec3_smooth, 15, 0.05);
    fragColor = mix(i_color_background, i_color_line, xx);
}