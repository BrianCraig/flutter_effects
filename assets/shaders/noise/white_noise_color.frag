#version 460 core

precision highp float;

#include <flutter/runtime_effect.glsl>

#include <../functions/standard_uniforms.glsl>

#include <../functions/transform2d_uniforms.glsl>

#include <../functions/random.glsl>

void main() {
    // we could use transformed uv, since this is noise we're gonna coord as input (no matrix transformation)
    // vec2 uv = uv_transofrmed_conserve_x();
    fragColor = vec4(random3(FlutterFragCoord() + i_translation), 1.0);
}