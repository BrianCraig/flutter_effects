#version 460 core

precision highp float;

#include <flutter/runtime_effect.glsl>

#include <../functions/standard_uniforms.glsl>

#include <../functions/transform2d_uniforms.glsl>

#include <../functions/random.glsl>

void main() {
    vec2 uv = floor(uv_transform2d() / (8.0 * i_dpr));

    fragColor = vec4(random3(uv), 1.0);
}