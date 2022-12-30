#version 460 core

precision highp float;

#include <flutter/runtime_effect.glsl>

#include <../functions/standard_uniforms.glsl>

#include <../functions/transform2d_uniforms.glsl>

#include <../functions/time_uniforms.glsl>

#include <../functions/voronoi/2d.glsl>

void main() {
    vec2 uv = uv_transform2d() / 16.0;
    float voronoi = voronoi2d(uv);
    fragColor = vec4(voronoi, voronoi, voronoi, 1.0);
}