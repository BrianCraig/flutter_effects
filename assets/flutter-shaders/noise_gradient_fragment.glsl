#version 460 core

precision highp float;

#include <flutter/runtime_effect.glsl>

#include <functions/noise.glsl>

#include <functions/near_step.glsl>

layout(location = 0) out vec4 fragColor;

layout(location = 0) uniform vec2 i_resolution;
layout(location = 1) uniform mat4 i_transformation;
layout(location = 2) uniform float i_time;


layout(location = 3) uniform float i_steps;

void main()
{
    vec2 mainuv = (FlutterFragCoord() / i_resolution) * vec2(i_resolution.x/i_resolution.y,1.0) - vec2(0.5, 0.5);
    vec2 uv = (vec4(mainuv.x, mainuv.y, 0.0, 1.0) * i_transformation).xy;

    vec4 color1 = vec4(1.0, 0.1, 0.3, 1.0);
    vec4 color2 = vec4(1.0, 1.0, 0.3, 1.0);
    
    float f = smoothstep(0.2, 0.8, noise2D(uv));
	
	fragColor = mix(color1, color2, nearStep(f, int(i_steps)));
}