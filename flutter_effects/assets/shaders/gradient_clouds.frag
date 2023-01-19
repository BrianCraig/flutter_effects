#version 460 core

precision highp float;

#include <flutter/runtime_effect.glsl>

#include <functions/standard_uniforms.glsl>

#include <functions/transform2d_uniforms.glsl>

#include <functions/time_uniforms.glsl>

#include <functions/gradient_noise_lib.glsl>

uniform vec4 i_line_color;
uniform vec4 i_first_color;
uniform vec4 i_second_color;

bool hash_bool(vec2 seed) {
    return source_hash_v1(seed) > 0;
}

// returns a value between 0 and 1, depending of the position
// of a triangle function that repeats from 0 to 2
float triangle_factor(float x) {
    return 1 - distance(mod(x, 2), 1);
}

const float PIXEL_SIZE = 32;
const float SPEED_MULTIPLIER = .3;

const float i_cloud_size = .25;
const float i_border_size = .03;

//#define DEBUG

float clamp_multiplied(float x, float edge, float mul) {
    return clamp(x * mul - edge * mul, 0, 1);
}

void main() {
    fragColor = vec4(0, 0, 0, 0.0);

    vec2 position = uv_transform2d() / (PIXEL_SIZE * i_dpr);
    float line_speed = source_hash_v1(vec2(round(position.y), 0));
    position = position + vec2(line_speed * i_time * SPEED_MULTIPLIER, 0);
    vec2 center = round(position);
    vec2 center_offset = position - center;
    float edge_distance = max(abs(center_offset.x), abs(center_offset.y));
    bool is_active = hash_bool(center);
    bool left_active = hash_bool(center - vec2(1, 0));
    bool right_active = hash_bool(center + vec2(1, 0));
    bool line_on = is_active && (center_offset.x < 0 ? left_active : right_active);
    float center_distance = distance(center, position);
    float line_y_distance = line_on ? abs(center_offset.y) : 1000;
    float line_distance = min(center_distance, line_y_distance);

    if(is_active && (left_active || right_active)) {
        vec4 cloud_color = mix(i_first_color, i_second_color, triangle_factor((position.y + .2) * 2));
        vec4 inColor = mix(cloud_color, i_line_color, clamp_multiplied(line_distance, i_cloud_size, 50 / i_scale));
        fragColor = mix(inColor, vec4(0), clamp_multiplied(line_distance, i_cloud_size + i_border_size, 50 / i_scale));

    }

    #ifdef DEBUG
    if(center_distance < .1) {
        fragColor.x += .5;
    };

    if(edge_distance > 0.45) {
        fragColor.x += .5;
    }

    if(is_active) {
        fragColor.y += .7;
    }

    if(line_distance < .2) {
        fragColor.z += .7;
    }
    #endif
}