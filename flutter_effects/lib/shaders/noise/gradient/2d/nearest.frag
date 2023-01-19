#version 460 core

precision highp float;

#include <flutter/runtime_effect.glsl>

#include <../../../functions/standard_uniforms.glsl>

#include <../../../functions/transform2d_uniforms.glsl>

#include <../../../functions/gradient_noise_lib.glsl>

const float  PIXEL_SIZE = 32;

void main() {
    vec2 position = uv_transform2d() / (PIXEL_SIZE * i_dpr);
    // nearest
    float r = source_hash_v1(round(position));
    r = smoothstep(-1, 1, r);
    fragColor = vec4(r, r, r, 1.0);
}