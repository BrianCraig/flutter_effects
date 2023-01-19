#version 460 core

precision highp float;

#include <flutter/runtime_effect.glsl>

#include <../functions/standard_uniforms.glsl>

#include <../functions/transform2d_uniforms.glsl>

#include <../functions/random.glsl>

void main() {
    // we transform the position, even when it's pure noise
    fragColor = vec4(random3(uv_transform2d()), 1.0);
}