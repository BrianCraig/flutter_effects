#version 460 core

precision highp float;

#include <flutter/runtime_effect.glsl>

float tanh(float val)
{
	float tmp = exp(val);
	float tanH = (tmp - 1.0 / tmp) / (tmp + 1.0 / tmp);
	return tanH;
}

#define pi 3.14159
#define rot(a) mat2(cos(a),sin(a),-sin(a),cos(a))
#define thc(a,b) tanh(a*cos(b))/tanh(a)
#define mlength(a) max(abs(a.x), abs(a.y))

layout(location = 0) out vec4 fragColor;

layout(location = 0) uniform vec2 i_resolution;
layout(location = 1) uniform mat4 i_transformation;
layout(location = 2) uniform float i_time;

float h21(vec2 a) {
    return fract(sin(dot(a.xy, vec2(12.9898, 78.233))) * 43758.5453123);
}

float box(in vec2 p, in vec2 b) {
    // Circle (sloppy)
    float d1 = length(p) - .56; 
    
    // Box
    vec2 d = abs(p)-b;
    float d2 = length(max(d,0.)) + min(max(d.x,d.y),0.);
    
    // Mix between them
    return mix(d1, d2, .5 + .5 * thc(4., i_time));
}

vec2 tile(vec2 fpos, vec2 ipos, float k) { 
    // Rotate tile randomly
    float h = floor(2. * h21(ipos));  
    fpos *= rot(h * pi / 2.);

    // Outlines of 2 boxes
    vec2 off = vec2(1.-.25, .25).xy;
    float s = smoothstep(-k, k, -abs(box(fpos+off,vec2(.5)))+.075);
    s = max(s,smoothstep(-k, k, -abs(box(fpos-off,vec2(.5)))+.075));                         
    
    // Checkerboard pattern
    float chk = mod(ipos.x + ipos.y, 2.);
    
    // Split the tiling into "in" and "out" parts
    // In by default
    float s2   = smoothstep(-k, k, -box(fpos + off, vec2(.5)));
    s2 = max(s2, smoothstep(-k, k, -box(fpos - off, vec2(.5))));  
    
    // Out if [checkerboard, rotate] == [0,0] or [1,1]
    if (chk == h)
        s2 = 1. - s2;

    // Return outline and in/out regions
    return vec2(s, s2);
}

vec3 layer(vec2 uv, float sc) {
    float k = sc / i_resolution.y;

    uv += 1.5 * k * vec2(.25, .75) * i_time;
    
    // Split into grid
    vec2 ipos = floor(sc * uv);
    vec2 fpos = fract(sc * uv);
       
    // Split into grid of big and small tiles
    float m = mod(2. * ipos.x - ipos.y, 5.);    
    vec2 o = vec2(0);
    if (m != 3.) {
        fpos *= 0.5;   
        if (m == 2.)      o = vec2(1,0); 
        else if (m == 4.) o = vec2(0,1); 
        else if (m == 1.) o = vec2(1);  
    }   
    fpos += .5 * o - .5;
    ipos -= o;
    
    if (m == 3.) { // Small tile
        float h = h21(ipos);
        float d = length(fpos) - .5 * h;
        float s = smoothstep(-k, k, -d + .25 * (1.-h));
        return vec3(0, 1. - mod(ipos.x + ipos.y, 2.), 1. - s);
    } else {       // Big tile     
        vec2 s = tile(fpos, ipos, .5 * k);
        float md = mod(ipos.x + ipos.y, 5.) / 5.;
        return vec3(s, 1);
    }
}



void main()
{
    vec2 uv = (FlutterFragCoord()-.5*i_resolution.xy)/i_resolution.y;
    
    // Layers
    float sc = 40.;
    vec3   s = layer(uv, sc);
    vec3  s2 = layer(uv + vec2(.432/sc), sc);

    vec3 col = .75 + .25 * cos(2. * pi * 
               (.65 * s.y + .05 * uv.x + vec3(0,1,2)/6.));
    
    // Dots
    col -= .1 * s.y * (1. - s.z) + .02 * s2.x;
    
    // Shadow
    col -= .3 * s2.y;
    
    // Thick outline
    col = mix(col, vec3(.1, 0, .15), s.x - .28 * s.y);   
    
    fragColor = vec4(col, 1);
}