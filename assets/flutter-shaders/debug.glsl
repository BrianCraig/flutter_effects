#version 460 core

precision highp float;

#include <flutter/runtime_effect.glsl>

layout(location = 0) out vec4 fragColor;

layout(location = 0) uniform vec2 i_resolution;
layout(location = 1) uniform mat4 i_transformation;
layout(location = 2) uniform float i_time;


void main()
{
    vec2 uv = FlutterFragCoord() / i_resolution - 0.5;

    uv = (vec4(uv.x, uv.y, 0.0, 1.0) * i_transformation).xy;
    
    vec4 lineColor = vec4(0.0, 0.0, 0.0, 1.0);

    vec4 col = vec4(1.0, 1.0, 1.0, 1.0);
    vec2 near_uv = abs(round(uv) - uv) * i_resolution;
    col = mix(col, lineColor, clamp(-min(near_uv.x, near_uv.y) + 3, 0.0, 1.0));
    col = mix(col, vec4(1.0, 0.0, 0.0, 1.0), clamp(-min(near_uv.x, near_uv.y) + 1, 0.0, 1.0));
    fragColor = col;
}