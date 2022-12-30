#version 460 core

precision highp float;

#include <flutter/runtime_effect.glsl>

#include <../functions/standard_uniforms.glsl>

#include <../functions/transform2d_uniforms.glsl>

#include <../functions/random.glsl>

void main() {
    // we transform the position, even when it's pure noise
    float r = random(uv_transform2d());
    fragColor = vec4(r, r, r, 1.0);
}