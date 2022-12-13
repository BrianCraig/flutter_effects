#version 460

precision highp float;

layout(location = 0) out vec4 fragColor;

//layout(location = 0) uniform float iTime;

layout(set=0, binding = 0) uniform TheBlock
{
    float theMember;
}; 

void main() {
  fragColor = vec4(1.0, cos(theMember), 0.0, 1.0);
}