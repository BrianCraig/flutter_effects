#version 460 core

precision highp float;

#include <flutter/runtime_effect.glsl>

#include <../functions/standard_uniforms.glsl>

#include <../functions/standard_uv.glsl>

float random(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898, 78.233))) *
        43758.5453123);
}

void main() {
    vec2 uv = uv_transofrmed_conserve_x();
    float r = random(uv);
    fragColor = vec4(r, r, r, 1.0);
}