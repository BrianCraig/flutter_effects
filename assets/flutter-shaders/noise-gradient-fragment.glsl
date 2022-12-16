#version 460 core

// The MIT License
// Copyright © 2013 Inigo Quilez
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions: The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software. THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
// https://www.youtube.com/c/InigoQuilez
// https://iquilezles.org/

// Value Noise (http://en.wikipedia.org/wiki/Value_noise), not to be confused with Perlin's
// Noise, is probably the simplest way to generate noise (a random smooth signal with 
// mostly all its energy in the low frequencies) suitable for procedural texturing/shading,
// modeling and animation.
//
// It produces lowe quality noise than Gradient Noise (https://www.shadertoy.com/view/XdXGW8)
// but it is slightly faster to compute. When used in a fractal construction, the blockyness
// of Value Noise gets qcuikly hidden, making it a very popular alternative to Gradient Noise.
//
// The principle is to create a virtual grid/latice all over the plane, and assign one
// random value to every vertex in the grid. When querying/requesting a noise value at
// an arbitrary point in the plane, the grid cell in which the query is performed is
// determined (line 30), the four vertices of the grid are determined and their random
// value fetched (lines 35 to 38) and then bilinearly interpolated (lines 35 to 38 again)
// with a smooth interpolant (line 31 and 33).


// Value    Noise 2D, Derivatives: https://www.shadertoy.com/view/4dXBRH
// Gradient Noise 2D, Derivatives: https://www.shadertoy.com/view/XdXBRH
// Value    Noise 3D, Derivatives: https://www.shadertoy.com/view/XsXfRH
// Gradient Noise 3D, Derivatives: https://www.shadertoy.com/view/4dffRH
// Value    Noise 2D             : https://www.shadertoy.com/view/lsf3WH <-- Based from here
// Value    Noise 3D             : https://www.shadertoy.com/view/4sfGzS
// Gradient Noise 2D             : https://www.shadertoy.com/view/XdXGW8
// Gradient Noise 3D             : https://www.shadertoy.com/view/Xsl3Dl
// Simplex  Noise 2D             : https://www.shadertoy.com/view/Msf3WH
// Wave     Noise 2D             : https://www.shadertoy.com/view/tldSRj

// Derivated of the above work, modified by Brian Craig

precision highp float;

#include <flutter/runtime_effect.glsl>

layout(location = 0) out vec4 fragColor;

layout(location = 0) uniform vec2 iResolution;
layout(location = 1) uniform vec2 iOffset;
layout(location = 2) uniform float iScale;

float noise_hash(vec2 p) 
{
    p  = 50.0*fract( p*0.3183099 + vec2(0.71,0.113));
    return -1.0+2.0*fract( p.x*p.y*(p.x+p.y) );
}

float noise_main( vec2 p ) // Noise origin
{
    vec2 i = floor( p );
    vec2 f = fract( p );
	
	vec2 u = f*f*(3.0-2.0*f);

    return mix( mix( noise_hash( i + vec2(0.0,0.0) ), 
                     noise_hash( i + vec2(1.0,0.0) ), u.x),
                mix( noise_hash( i + vec2(0.0,1.0) ), 
                     noise_hash( i + vec2(1.0,1.0) ), u.x), u.y);
}

float noise2D(vec2 uv){ // Smooth
    mat2 m = mat2( 1.6,  1.2, -1.2,  1.6 );
	float f = 0.5000 * noise_main( uv ); 
    uv = m*uv;
	f += 0.2500 * noise_main( uv ); 
    uv = m*uv;
	f += 0.1250 * noise_main( uv ); 
    uv = m*uv;
	f += 0.0625 * noise_main( uv ); 
    uv = m*uv;
	f = 0.5 + 0.5 * f;
    return f;
}

float nearStep(float x, int steps){
    return round(x * (steps - 1)) / (steps - 1);
}

void main()
{
    vec2 p = ((FlutterFragCoord() / iResolution) - vec2(0.5, 0.5)) * iScale;

	vec2 uv = p*vec2(iResolution.x/iResolution.y,1.0) + iOffset;
    vec4 color1 = vec4(1.0, 0.1, 0.3, 1.0);
    vec4 color2 = vec4(1.0, 1.0, 0.3, 1.0);
    
    float f = smoothstep(0.2, 0.8, noise2D(uv));
	
	fragColor = mix(color1, color2, nearStep(f, 8));
}