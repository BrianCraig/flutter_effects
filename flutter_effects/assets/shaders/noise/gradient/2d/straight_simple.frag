#version 460 core

precision highp float;

#include <flutter/runtime_effect.glsl>

#include <../../../functions/standard_uniforms.glsl>

#include <../../../functions/transform2d_uniforms.glsl>

#define INTERPOLATION interpolation_simple

#include <../../../functions/gradient_noise_lib.glsl>

const float  PIXEL_SIZE = 32;

void main() {
    vec2 position = uv_transform2d() / (PIXEL_SIZE * i_dpr);
    // nearest
    float r = straight_noise(position);
    fragColor = vec4(r, r, r, 1.0); 
}