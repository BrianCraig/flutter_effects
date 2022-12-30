#version 460 core

precision highp float;

#include <flutter/runtime_effect.glsl>

#include <../functions/standard_uniforms.glsl>

#include <../functions/transform2d_uniforms.glsl>

#include <../functions/random.glsl>

vec2 rotate(vec2 original, float rotation) {
  float s = sin(rotation);
  float c = cos(rotation);

  return vec2(original.x * c - original.y * s,  original.x * s + original.y * c);
}

void main() {

    // start with a centered res
    vec2 uv = FlutterFragCoord() - (i_resolution / 2);

    uv = rotate(uv, i_rotation);

    uv *= i_scale; 

    uv += i_translation; 

    uv = floor( uv / (8.0 * i_dpr));

    fragColor = vec4(random3(uv), 1.0);
}