#version 440

precision highp float;

layout(location = 0) out vec4 fragColor;

layout(location = 0) uniform float iTime;

void main() {
  fragColor = vec4(1.0, cos(iTime), 0.0, 1.0);
}