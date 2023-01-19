#version 460 core

precision highp float;

#include <flutter/runtime_effect.glsl>

#include <../functions/standard_uniforms.glsl>

#include <../functions/transform2d_uniforms.glsl>

#include <../functions/time_uniforms.glsl>

#include <../functions/voronoi/3d.glsl>

void main() {
    vec2 uv = uv_transform2d();
    vec3 vor = voronoi3d(vec3(uv / 16.0, i_time));
    fragColor = vec4(vor.x, vor.x, vor.x, 1.0);
}