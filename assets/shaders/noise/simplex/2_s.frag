#version 460 core

precision highp float;

#include <flutter/runtime_effect.glsl>

#include <../../functions/standard_uniforms.glsl>

#include <../../functions/transform2d_uniforms.glsl>

#include <../../functions/time_uniforms.glsl>

#include <../../functions/simplex/open_simplex_2_s.glsl>

const float PIXEL_SIZE = 32;

void main() {
    vec2 position = uv_transform2d() / (PIXEL_SIZE * i_dpr);
    vec4 noise = openSimplex2SDerivatives_ImproveXY(vec3(position, i_time));
    //fragColor = simplexFixer(vec4(noise.xyz, 1));
    fragColor = vec4(vec3(noise.w/2+.5), 1);
}